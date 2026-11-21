//
//  VoiceInputViewModel.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import Observation

@Observable
final class VoiceInputViewModel {
    private(set) var transcript = ""
    private(set) var isRecording = false

    private var transcriptTask: Task<Void, Never>?

    private let service: any VoiceInputServiceProtocol

    init(service: any VoiceInputServiceProtocol) {
        self.service = service
    }

    func toggleRecording() async {
        if isRecording {
            stopRecording()
        } else {
            await startRecording()
        }
    }

    func stopRecording() {
        service.stopRecognition()
        isRecording = false
    }

    private func startRecording() async {
        guard await service.requestAuthorization(),
              let stream = try? service.startRecognition() else { return }

        transcriptTask?.cancel()
        isRecording = true
        transcriptTask = Task {
            for await text in stream {
                transcript = text
            }

            guard !Task.isCancelled else { return }
            stopRecording()
        }
    }
}
