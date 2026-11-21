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
    private var transcript = ""
    private var transcriptTask: Task<Void, Never>?

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
        async let childNames = fetchChildNames()

        guard await service.requestAuthorization(), !Task.isCancelled else { return }
        guard let stream = try? service.startRecognition(contextualStrings: await childNames)
        else { return }

        transcriptTask?.cancel()
        transcriptTask = Task {
            for await text in stream {
                transcript = text
            }
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
        _ = try? await careRecordService.createCareRecords(CareRecordDraftModel(text: text))
    }

    private func fetchChildNames() async -> [String] {
        let children = await withTaskGroup(of: [ChildModel]?.self) { group in
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
        return children.flatMap(\.spokenNames)
    }
}

private extension VoiceInputViewModel {
    enum Limit {
        static let childNamesTimeout: Duration = .milliseconds(700)
    }
}
