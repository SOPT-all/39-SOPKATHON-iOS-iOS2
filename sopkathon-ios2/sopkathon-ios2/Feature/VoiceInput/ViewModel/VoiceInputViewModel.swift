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

    init(
        service: any VoiceInputServiceProtocol,
        careRecordService: any CareRecordServiceProtocol
    ) {
        self.service = service
        self.careRecordService = careRecordService
    }

    func startRecording() async {
        guard await service.requestAuthorization(),
              !Task.isCancelled,
              let stream = try? service.startRecognition() else { return }

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
}
