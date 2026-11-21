//
//  PhoneSyncService.swift
//  SopkathonWatch
//
//  Created by h2e on 11/22/26.
//

import Foundation
import WatchConnectivity

protocol PhoneSyncServiceProtocol {
    func notifyCareRecordSaved()
}

final class PhoneSyncService: NSObject {
    func activate() {
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }
}

extension PhoneSyncService: PhoneSyncServiceProtocol {
    func notifyCareRecordSaved() {
        let session = WCSession.default
        guard session.activationState == .activated else { return }

        let message = WatchSyncMessage.careRecordSavedMessage
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil)
        } else {
            session.transferUserInfo(message)
        }
    }
}

extension PhoneSyncService: WCSessionDelegate {
    nonisolated func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {}
}
