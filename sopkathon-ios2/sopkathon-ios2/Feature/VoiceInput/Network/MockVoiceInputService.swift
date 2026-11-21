//
//  MockVoiceInputService.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import Foundation

final class MockVoiceInputService {
    private var recognitionTask: Task<Void, Never>?
}

extension MockVoiceInputService: VoiceInputServiceProtocol {
    func requestAuthorization() async -> Bool {
        true
    }

    func startRecognition() throws -> AsyncStream<String> {
        stopRecognition()

        let (stream, continuation) = AsyncStream.makeStream(of: String.self)
        recognitionTask = Task {
            var transcript = ""
            for word in Sample.words {
                try? await Task.sleep(for: Sample.interval)
                guard !Task.isCancelled else { break }
                transcript = transcript.isEmpty ? word : transcript + Sample.separator + word
                continuation.yield(transcript)
            }
            continuation.finish()
        }
        return stream
    }

    func stopRecognition() {
        recognitionTask?.cancel()
        recognitionTask = nil
    }
}

private extension MockVoiceInputService {
    enum Sample {
        static let words = ["지우가", "점심을", "남기지", "않고", "다", "먹었어요"]
        static let separator = " "
        static let interval: Duration = .milliseconds(400)
    }
}
