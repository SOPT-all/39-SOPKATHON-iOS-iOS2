//
//  WatchSyncMessage.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

enum WatchSyncMessage {
    static let eventKey = "event"
    static let careRecordSaved = "careRecordSaved"

    static var careRecordSavedMessage: [String: Any] {
        [eventKey: careRecordSaved]
    }

    static func isCareRecordSaved(_ message: [String: Any]) -> Bool {
        message[eventKey] as? String == careRecordSaved
    }
}
