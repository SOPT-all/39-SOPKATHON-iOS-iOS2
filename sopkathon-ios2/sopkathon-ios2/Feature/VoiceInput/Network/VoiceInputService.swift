//
//  VoiceInputService.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import AVFoundation
import Speech

protocol VoiceInputServiceProtocol {
    func requestAuthorization() async -> Bool
    func startRecognition(contextualStrings: [String]) throws -> AsyncStream<String>
    func transcribeRecording(at url: URL, contextualStrings: [String]) async throws -> String
    func stopRecognition()
}

enum VoiceInputError: Error {
    case recognizerUnavailable
    case microphoneUnavailable
}

final class VoiceInputService {
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(
        locale: Locale(identifier: Constant.localeIdentifier)
    )
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
}

extension VoiceInputService: VoiceInputServiceProtocol {
    func requestAuthorization() async -> Bool {
        guard await Self.requestSpeechAuthorization() else { return false }
        return await AVAudioApplication.requestRecordPermission()
    }

    func startRecognition(contextualStrings: [String]) throws -> AsyncStream<String> {
        stopRecognition()

        guard let speechRecognizer, speechRecognizer.isAvailable else {
            throw VoiceInputError.recognizerUnavailable
        }

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.contextualStrings = contextualStrings

        do {
            try startAudioEngine(appendingTo: request)
        } catch {
            stopRecognition()
            throw error
        }

        let (stream, continuation) = AsyncStream.makeStream(of: String.self)
        recognitionRequest = request
        recognitionTask = Self.makeRecognitionTask(
            recognizer: speechRecognizer,
            request: request,
            continuation: continuation
        )
        return stream
    }

    func transcribeRecording(at url: URL, contextualStrings: [String]) async throws -> String {
        guard let speechRecognizer, speechRecognizer.isAvailable else {
            throw VoiceInputError.recognizerUnavailable
        }

        let request = SFSpeechURLRecognitionRequest(url: url)
        request.shouldReportPartialResults = false
        request.contextualStrings = contextualStrings
        return try await Self.transcribe(request, with: speechRecognizer)
    }

    func stopRecognition() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: Constant.bus)
        recognitionRequest?.endAudio()
        recognitionTask?.finish()
        recognitionRequest = nil
        recognitionTask = nil
        try? AVAudioSession.sharedInstance().setActive(
            false,
            options: .notifyOthersOnDeactivation
        )
    }
}

private extension VoiceInputService {
    enum Constant {
        static let localeIdentifier = "ko-KR"
        static let bus: AVAudioNodeBus = 0
        static let bufferSize: AVAudioFrameCount = 1024
    }

    func startAudioEngine(appendingTo request: SFSpeechAudioBufferRecognitionRequest) throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: Constant.bus)
        guard format.sampleRate > 0, format.channelCount > 0 else {
            throw VoiceInputError.microphoneUnavailable
        }

        Self.installTap(on: inputNode, format: format, request: request)
        audioEngine.prepare()
        try audioEngine.start()
    }

    nonisolated static func transcribe(
        _ request: SFSpeechURLRecognitionRequest,
        with recognizer: SFSpeechRecognizer
    ) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            var hasResumed = false
            recognizer.recognitionTask(with: request) { result, error in
                guard !hasResumed else { return }

                if let result, result.isFinal {
                    hasResumed = true
                    continuation.resume(returning: result.bestTranscription.formattedString)
                } else if let error {
                    hasResumed = true
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    nonisolated static func requestSpeechAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }

    nonisolated static func installTap(
        on inputNode: AVAudioInputNode,
        format: AVAudioFormat,
        request: SFSpeechAudioBufferRecognitionRequest
    ) {
        inputNode.installTap(
            onBus: Constant.bus,
            bufferSize: Constant.bufferSize,
            format: format
        ) { buffer, _ in
            request.append(buffer)
        }
    }

    nonisolated static func makeRecognitionTask(
        recognizer: SFSpeechRecognizer,
        request: SFSpeechAudioBufferRecognitionRequest,
        continuation: AsyncStream<String>.Continuation
    ) -> SFSpeechRecognitionTask {
        recognizer.recognitionTask(with: request) { result, error in
            if let result {
                continuation.yield(result.bestTranscription.formattedString)
            }

            guard error != nil || result?.isFinal == true else { return }
            continuation.finish()
        }
    }
}

extension AppDependency {
    var voiceInputService: any VoiceInputServiceProtocol {
        switch mode {
        case .live:
            return VoiceInputService()
        case .mock:
            return MockVoiceInputService()
        }
    }
}
