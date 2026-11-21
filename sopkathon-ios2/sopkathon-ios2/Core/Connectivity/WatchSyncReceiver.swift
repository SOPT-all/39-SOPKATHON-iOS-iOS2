//
//  WatchSyncReceiver.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import Foundation
import Observation
import WatchConnectivity

@Observable
final class WatchSyncReceiver: NSObject {
    private(set) var careRecordSavedCount = 0

    private let voiceInputService: any VoiceInputServiceProtocol
    private let careRecordService: any CareRecordServiceProtocol
    private let childService: any ChildServiceProtocol

    init(
        voiceInputService: any VoiceInputServiceProtocol,
        careRecordService: any CareRecordServiceProtocol,
        childService: any ChildServiceProtocol
    ) {
        self.voiceInputService = voiceInputService
        self.careRecordService = careRecordService
        self.childService = childService
    }

    func activate() {
        guard WCSession.isSupported() else { return }

        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    private func saveCareRecords(fromRecordingAt url: URL) async {
        defer { try? FileManager.default.removeItem(at: url) }

        let children = (try? await childService.fetchChildren(keyword: nil)) ?? []
        guard await voiceInputService.requestAuthorization(),
              let text = try? await voiceInputService.transcribeRecording(
                at: url,
                contextualStrings: children.flatMap(\.spokenNames)
              ),
              !text.isEmpty,
              (try? await careRecordService.createCareRecords(
                CareRecordDraftModel(text: text)
              )) != nil
        else { return }
        careRecordSavedCount += 1
    }
}

extension WatchSyncReceiver: WCSessionDelegate {
    nonisolated func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {}

    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {}

    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }

    nonisolated func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let url = FileManager.default.temporaryDirectory
            .appending(path: UUID().uuidString)
            .appendingPathExtension(file.fileURL.pathExtension)
        guard (try? FileManager.default.moveItem(at: file.fileURL, to: url)) != nil else { return }

        Task { @MainActor in
            await saveCareRecords(fromRecordingAt: url)
        }
    }
}
