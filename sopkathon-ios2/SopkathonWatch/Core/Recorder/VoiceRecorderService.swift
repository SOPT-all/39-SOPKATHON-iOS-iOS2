//
//  VoiceRecorderService.swift
//  SopkathonWatch
//
//  Created by h2e on 11/22/26.
//

import AVFoundation

protocol VoiceRecorderServiceProtocol {
    var currentLevel: Double { get }
    var currentTime: TimeInterval { get }

    func requestPermission() async -> Bool
    func startRecording() throws
    func pauseRecording()
    func resumeRecording()
    func stopRecording() -> URL?
}

enum VoiceRecorderError: Error {
    case recordingFailed
}

final class VoiceRecorderService {
    private var recorder: AVAudioRecorder?
}

extension VoiceRecorderService: VoiceRecorderServiceProtocol {
    var currentLevel: Double {
        guard let recorder, recorder.isRecording else { return 0 }

        recorder.updateMeters()
        let power = Double(recorder.averagePower(forChannel: Constant.channel))
        let level = (power - Constant.minimumPower) / -Constant.minimumPower
        return min(max(level, 0), 1)
    }

    var currentTime: TimeInterval {
        recorder?.currentTime ?? 0
    }

    func requestPermission() async -> Bool {
        await AVAudioApplication.requestRecordPermission()
    }

    func startRecording() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .default)
        try audioSession.setActive(true)

        let url = FileManager.default.temporaryDirectory.appending(path: Constant.fileName)
        let recorder = try AVAudioRecorder(url: url, settings: Constant.settings)
        recorder.isMeteringEnabled = true
        guard recorder.record() else { throw VoiceRecorderError.recordingFailed }
        self.recorder = recorder
    }

    func pauseRecording() {
        recorder?.pause()
    }

    func resumeRecording() {
        recorder?.record()
    }

    func stopRecording() -> URL? {
        guard let recorder else { return nil }

        recorder.stop()
        self.recorder = nil
        try? AVAudioSession.sharedInstance().setActive(false)
        return recorder.url
    }
}

private extension VoiceRecorderService {
    enum Constant {
        static let fileName = "voice-memo.m4a"
        static let channel = 0
        static let minimumPower: Double = -50
        static let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 16_000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }
}

extension AppDependency {
    var voiceRecorderService: any VoiceRecorderServiceProtocol {
        switch mode {
        case .live:
            return VoiceRecorderService()
        case .mock:
            return MockVoiceRecorderService()
        }
    }
}
