//
//  BriefingViewModel.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

import Foundation
import Observation

@Observable
final class BriefingViewModel {
    private(set) var briefing: BriefingModel?
    private(set) var generatingKidID: Int?
    private(set) var refiningBriefingID: Int?
    private(set) var sentKidIDs: Set<Int> = []

    var isMockPreview: Bool { service.isMock }
    var briefingDateText: String {
        guard let date = briefing?.date else { return "" }
        let components = date.split(separator: "-")
        guard components.count == 3,
              let month = Int(components[1]),
              let day = Int(components[2])
        else { return date }
        return "\(components[0])년 \(month)월 \(day)일"
    }

    private var requestedDateString: String?
    private var latestFetchRequestID = 0

    private let service: any BriefingServiceProtocol

    init(service: any BriefingServiceProtocol) {
        self.service = service
    }

    func fetchDailyBriefings() async {
        latestFetchRequestID += 1
        let requestID = latestFetchRequestID

        guard let briefing = try? await service.fetchDailyBriefings() else {
            return
        }
        guard latestFetchRequestID == requestID else { return }
        self.briefing = briefing
        requestedDateString = briefing.date
        if service.isMock {
            sentKidIDs = []
        } else {
            let storedIDs = UserDefaults.standard.array(forKey: sentKey(for: briefing.date)) as? [Int]
            sentKidIDs = Set(storedIDs ?? [])
        }
    }

    func markSent(kidID: Int) {
        guard let briefing,
              briefing.date == requestedDateString,
              briefing.kids.contains(where: { $0.id == kidID })
        else { return }

        sentKidIDs.insert(kidID)
        if !service.isMock {
            UserDefaults.standard.set(Array(sentKidIDs), forKey: sentKey(for: briefing.date))
        }
    }

    func isSent(kidID: Int) -> Bool {
        sentKidIDs.contains(kidID)
    }

    func prepareDailyBriefing(kidID: Int) async {
        guard let kid = briefing?.kids.first(where: { $0.id == kidID }),
              kid.briefing == nil
        else { return }
        await createDailyBriefing(kidID: kidID)
    }

    private func createDailyBriefing(kidID: Int) async {
        guard generatingKidID == nil, refiningBriefingID == nil else { return }
        guard let dateString = requestedDateString,
              briefing?.date == dateString,
              briefing?.kids.contains(where: { $0.id == kidID }) == true
        else { return }

        generatingKidID = kidID
        defer { generatingKidID = nil }

        guard let message = try? await service.createDailyBriefing(
            kidID: kidID,
            date: dateString
        ) else { return }
        guard requestedDateString == dateString,
              var briefing,
              briefing.date == dateString,
              let index = briefing.kids.firstIndex(where: { $0.id == kidID })
        else { return }
        latestFetchRequestID += 1
        briefing.kids[index].briefing = message
        self.briefing = briefing
    }

    func updateDailyBriefing(briefingID: Int, instruction: String) async {
        guard generatingKidID == nil, refiningBriefingID == nil else { return }
        guard !instruction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard let requestedDateString,
              let briefing,
              briefing.date == requestedDateString,
              briefing.kids.contains(where: { $0.briefing?.id == briefingID })
        else { return }

        refiningBriefingID = briefingID
        defer { refiningBriefingID = nil }

        guard let message = try? await service.updateDailyBriefing(
            briefingID: briefingID,
            instruction: instruction
        ) else { return }
        guard self.requestedDateString == requestedDateString,
              var briefing = self.briefing,
              briefing.date == requestedDateString,
              let index = briefing.kids.firstIndex(where: { $0.briefing?.id == message.id })
        else { return }
        latestFetchRequestID += 1
        briefing.kids[index].briefing = message
        self.briefing = briefing
    }

    private func sentKey(for date: String) -> String {
        "briefing.sent.\(date)"
    }
}
