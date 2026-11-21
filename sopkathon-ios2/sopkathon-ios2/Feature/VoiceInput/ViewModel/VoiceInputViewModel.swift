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
    private var childrenTask: Task<Void, Never>?
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

    func fetchChildren() async {
        guard let children = try? await childService.fetchChildren(keyword: nil) else { return }
        self.children = children
    }

    func startRecording() async {
        transcript = ""
        childrenTask = Task {
            await fetchChildren()
        }

        guard await service.requestAuthorization(), !Task.isCancelled else { return }
        guard let recognition = try? service.startRecognition(
            contextualStrings: children.flatMap(\.recognitionHints)
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

    func completeRecording() async -> Bool {
        service.stopRecognition()
        await transcriptTask?.value

        let text = transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else {
            #if DEBUG
            print("[Voice] 인식된 문장이 없습니다")
            #endif
            return false
        }
        await childrenTask?.value
        let records = await careRecordService.createCareRecords(
            fromSpokenText: text,
            mentioning: children
        )
        return !records.isEmpty
    }
}

private extension VoiceInputViewModel {
    enum Limit {
        static let audioLevelDecay: Float = 0.85
    }
}
