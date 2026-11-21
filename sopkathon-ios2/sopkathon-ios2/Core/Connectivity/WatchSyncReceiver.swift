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

    func activate() {
        guard WCSession.isSupported() else { return }

        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    private nonisolated func handle(_ message: [String: Any]) {
        guard WatchSyncMessage.isCareRecordSaved(message) else { return }

        Task { @MainActor in
            careRecordSavedCount += 1
        }
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

    nonisolated func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        handle(message)
    }

    nonisolated func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String: Any] = [:]
    ) {
        handle(userInfo)
    }
}
