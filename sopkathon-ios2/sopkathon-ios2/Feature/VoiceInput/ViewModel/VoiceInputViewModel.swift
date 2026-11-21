//
//  VoiceInputViewModel.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import Foundation
import Observation

@Observable
final class VoiceInputViewModel {
    private(set) var audioLevel: Float = 0

    private var transcript = ""
    private var children: [ChildModel] = []
    private var transcriptTask: Task<Void, Never>?
    private var audioLevelTask: Task<Void, Never>?

    private let service: any VoiceInputServiceProtocol
    private let careRecordService: any CareRecordServiceProtocol
    private let childService: any ChildServiceProtocol

    init(
        service: any VoiceInputServiceProtocol,
        careRecordService: any CareRecordServiceProtocol,
        childService: any ChildServiceProtocol
    ) {
        self.service = service
        self.careRecordService = careRecordService
        self.childService = childService
    }

    func startRecording() async {
        async let fetchedChildren = fetchChildren()

        guard await service.requestAuthorization(), !Task.isCancelled else { return }
        children = await fetchedChildren
        guard let recognition = try? service.startRecognition(
            contextualStrings: children.flatMap(\.spokenNames)
        ) else { return }

        transcriptTask?.cancel()
        transcriptTask = Task {
            for await text in recognition.transcripts {
                transcript = text
            }
        }

        audioLevelTask?.cancel()
        audioLevelTask = Task {
            for await level in recognition.audioLevels {
                audioLevel = max(level, audioLevel * Limit.audioLevelDecay)
            }
            audioLevel = 0
        }
    }

    func cancelRecording() {
        service.stopRecognition()
    }

    func completeRecording() async {
        service.stopRecognition()
        await transcriptTask?.value

        let text = transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        if children.isEmpty {
            children = (try? await childService.fetchChildren(keyword: nil)) ?? []
        }
        _ = await careRecordService.createCareRecords(
            fromSpokenText: text,
            mentioning: children
        )
    }

    private func fetchChildren() async -> [ChildModel] {
        await withTaskGroup(of: [ChildModel]?.self) { group in
            group.addTask { [childService] in
                try? await childService.fetchChildren(keyword: nil)
            }
            group.addTask {
                try? await Task.sleep(for: Limit.childNamesTimeout)
                return nil
            }

            let children = await group.next() ?? nil
            group.cancelAll()
            return children ?? []
        }
    }
}

private extension VoiceInputViewModel {
    enum Limit {
        static let childNamesTimeout: Duration = .milliseconds(700)
        static let audioLevelDecay: Float = 0.85
    }
}
