//
//  VoiceMemoViewModel.swift
//  SopkathonWatch
//
//  Created by h2e on 11/22/26.
//

import Foundation
import Observation

@Observable
final class VoiceMemoViewModel {
    private(set) var phase: VoiceMemoPhaseModel = .ready
    private(set) var levels = Wave.emptyLevels
    private(set) var elapsedSeconds = 0

    var elapsedText: String {
        String(
            format: Wave.elapsedFormat,
            elapsedSeconds / Wave.secondsPerMinute,
            elapsedSeconds % Wave.secondsPerMinute
        )
    }

    private var meteringTask: Task<Void, Never>?

    private let recorderService: any VoiceRecorderServiceProtocol
    private let phoneSyncService: any PhoneSyncServiceProtocol

    init(
        recorderService: any VoiceRecorderServiceProtocol,
        phoneSyncService: any PhoneSyncServiceProtocol
    ) {
        self.recorderService = recorderService
        self.phoneSyncService = phoneSyncService
    }

    func startRecording() async {
        guard await recorderService.requestPermission(),
              (try? recorderService.startRecording()) != nil else { return }

        phase = .recording
        startMetering()
    }

    func togglePause() {
        switch phase {
        case .recording:
            recorderService.pauseRecording()
            phase = .paused
        case .paused:
            recorderService.resumeRecording()
            phase = .recording
        case .ready, .sending, .sent:
            break
        }
    }

    func finishRecording() async {
        meteringTask?.cancel()
        guard let url = recorderService.stopRecording() else {
            resetMemo()
            return
        }

        phase = .sending
        guard await phoneSyncService.sendRecording(at: url) else {
            resetMemo()
            return
        }
        phase = .sent
    }

    func resetMemo() {
        phase = .ready
        levels = Wave.emptyLevels
        elapsedSeconds = 0
    }

    private func startMetering() {
        meteringTask?.cancel()
        meteringTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: Wave.meteringInterval)
                guard !Task.isCancelled, phase == .recording else { continue }

                levels.removeFirst()
                levels.append(recorderService.currentLevel)
                elapsedSeconds = Int(recorderService.currentTime)
            }
        }
    }
}

private extension VoiceMemoViewModel {
    enum Wave {
        static let barCount = 27
        static let emptyLevels = Array(repeating: 0.0, count: barCount)
        static let meteringInterval: Duration = .milliseconds(80)
        static let secondsPerMinute = 60
        static let elapsedFormat = "%02d:%02d"
    }
}
