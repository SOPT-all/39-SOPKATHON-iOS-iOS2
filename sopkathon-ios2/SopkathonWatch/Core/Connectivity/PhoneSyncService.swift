//
//  PhoneSyncService.swift
//  SopkathonWatch
//
//  Created by h2e on 11/22/26.
//

import WatchConnectivity

protocol PhoneSyncServiceProtocol {
    func sendRecording(at url: URL) async -> Bool
}

final class PhoneSyncService: NSObject {
    private var continuations: [WCSessionFileTransfer: CheckedContinuation<Bool, Never>] = [:]

    func activate() {
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    private func finishTransfer(_ fileTransfer: WCSessionFileTransfer, isSuccess: Bool) {
        continuations.removeValue(forKey: fileTransfer)?.resume(returning: isSuccess)
    }
}

extension PhoneSyncService: PhoneSyncServiceProtocol {
    func sendRecording(at url: URL) async -> Bool {
        let session = WCSession.default
        guard session.activationState == .activated else { return false }

        return await withCheckedContinuation { continuation in
            let fileTransfer = session.transferFile(url, metadata: nil)
            continuations[fileTransfer] = continuation
        }
    }
}

extension PhoneSyncService: WCSessionDelegate {
    nonisolated func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {}

    nonisolated func session(
        _ session: WCSession,
        didFinish fileTransfer: WCSessionFileTransfer,
        error: (any Error)?
    ) {
        let isSuccess = error == nil
        Task { @MainActor in
            finishTransfer(fileTransfer, isSuccess: isSuccess)
        }
    }
}

extension AppDependency {
    var phoneSyncService: any PhoneSyncServiceProtocol {
        switch mode {
        case .live:
            let service = PhoneSyncService()
            service.activate()
            return service
        case .mock:
            return MockPhoneSyncService()
        }
    }
}
