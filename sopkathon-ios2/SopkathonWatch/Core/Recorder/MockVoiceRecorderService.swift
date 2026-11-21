//
//  MockVoiceRecorderService.swift
//  SopkathonWatch
//
//  Created by h2e on 11/22/26.
//

import Foundation

final class MockVoiceRecorderService {
    private var startDate: Date?
    private var isPaused = false
}

extension MockVoiceRecorderService: VoiceRecorderServiceProtocol {
    var currentLevel: Double {
        guard startDate != nil, !isPaused else { return 0 }
        return Double.random(in: Sample.levelRange)
    }

    var currentTime: TimeInterval {
        guard let startDate else { return 0 }
        return Date().timeIntervalSince(startDate)
    }

    func requestPermission() async -> Bool {
        true
    }

    func startRecording() throws {
        startDate = Date()
        isPaused = false
    }

    func pauseRecording() {
        isPaused = true
    }

    func resumeRecording() {
        isPaused = false
    }

    func stopRecording() -> URL? {
        startDate = nil
        return FileManager.default.temporaryDirectory.appending(path: Sample.fileName)
    }
}

private extension MockVoiceRecorderService {
    enum Sample {
        static let levelRange = 0.05...1.0
        static let fileName = "mock-voice-memo.m4a"
    }
}
