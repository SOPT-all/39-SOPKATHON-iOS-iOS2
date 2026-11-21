//
//  WatchSyncReceiver.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import Observation
import UIKit
import WatchConnectivity

@Observable
final class WatchSyncReceiver: NSObject {
    private(set) var careRecordSavedCount = 0

    private let voiceInputService: any VoiceInputServiceProtocol
    private let careRecordService: any CareRecordServiceProtocol
    private let childService: any ChildServiceProtocol
    private let notificationService: any LocalNotificationServiceProtocol

    init(
        voiceInputService: any VoiceInputServiceProtocol,
        careRecordService: any CareRecordServiceProtocol,
        childService: any ChildServiceProtocol,
        notificationService: any LocalNotificationServiceProtocol
    ) {
        self.voiceInputService = voiceInputService
        self.careRecordService = careRecordService
        self.childService = childService
        self.notificationService = notificationService
    }

    func activate() {
        guard WCSession.isSupported() else { return }

        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    private func saveCareRecords(fromRecordingAt url: URL) async {
        defer { try? FileManager.default.removeItem(at: url) }

        guard let records = await createCareRecords(fromRecordingAt: url) else {
            await notificationService.sendNotification(
                title: Message.failedTitle,
                body: Message.failedBody
            )
            return
        }

        careRecordSavedCount += 1
        await notificationService.sendNotification(
            title: Message.savedTitle,
            body: makeSavedBody(of: records)
        )
    }

    private func createCareRecords(fromRecordingAt url: URL) async -> [CareRecordModel]? {
        let children = (try? await childService.fetchChildren(keyword: nil)) ?? []
        guard await voiceInputService.requestAuthorization(),
              let text = try? await voiceInputService.transcribeRecording(
                at: url,
                contextualStrings: children.flatMap(\.spokenNames)
              ),
              !text.isEmpty else { return nil }
        let records = await careRecordService.createCareRecords(
            fromSpokenText: text,
            mentioning: children
        )
        return records.isEmpty ? nil : records
    }

    private func makeSavedBody(of records: [CareRecordModel]) -> String {
        var childNames: [String] = []
        for record in records where !childNames.contains(record.childName) {
            childNames.append(record.childName)
        }
        return childNames.joined(separator: Message.nameSeparator) + Message.childSuffix
    }
}

private extension WatchSyncReceiver {
    enum Message {
        static let savedTitle = "돌봄 기록이 저장됐어요."
        static let failedTitle = "기록을 저장하지 못했어요"
        static let failedBody = "아이 이름과 함께 다시 말해 주세요."
        static let nameSeparator = ", "
        static let childSuffix = " 어린이"
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
            let backgroundTaskID = UIApplication.shared.beginBackgroundTask()
            await saveCareRecords(fromRecordingAt: url)
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
        }
    }
}
