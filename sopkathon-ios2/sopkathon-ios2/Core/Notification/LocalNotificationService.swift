//
//  LocalNotificationService.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import Observation
import UserNotifications

protocol LocalNotificationServiceProtocol {
    func sendNotification(title: String, body: String) async
}

@Observable
final class LocalNotificationService: NSObject {
    private(set) var openedCount = 0

    func activate() async {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        _ = try? await center.requestAuthorization(options: [.alert, .sound])
    }

    private func increaseOpenedCount() {
        openedCount += 1
    }
}

extension LocalNotificationService: LocalNotificationServiceProtocol {
    func sendNotification(title: String, body: String) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        try? await UNUserNotificationCenter.current().add(request)
    }
}

extension LocalNotificationService: UNUserNotificationCenterDelegate {
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        await increaseOpenedCount()
    }
}
