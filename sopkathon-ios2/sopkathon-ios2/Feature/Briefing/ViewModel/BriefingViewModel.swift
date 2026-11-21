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

    private var requestedDateString: String?
    private var latestFetchRequestID = 0

    private let service: any BriefingServiceProtocol

    init(service: any BriefingServiceProtocol) {
        self.service = service
    }

    func fetchDailyBriefings(for date: Date) async {
        let dateString = formattedDate(date)
        requestedDateString = dateString
        latestFetchRequestID += 1
        let requestID = latestFetchRequestID

        guard let briefing = try? await service.fetchDailyBriefings(date: dateString) else {
            return
        }
        guard latestFetchRequestID == requestID else { return }
        self.briefing = briefing
    }

    func isBriefing(for date: Date) -> Bool {
        briefing?.date == formattedDate(date)
    }

    func createDailyBriefing(kidID: Int, for date: Date) async {
        guard generatingKidID == nil, refiningBriefingID == nil else { return }
        let dateString = formattedDate(date)
        guard requestedDateString == dateString,
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

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
