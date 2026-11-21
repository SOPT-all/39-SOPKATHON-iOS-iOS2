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

    private let service: any BriefingServiceProtocol

    init(service: any BriefingServiceProtocol) {
        self.service = service
    }

    func fetchDailyBriefings(for date: Date) async {
        let dateString = formattedDate(date)
        guard let briefing = try? await service.fetchDailyBriefings(date: dateString) else {
            return
        }
        self.briefing = briefing
    }

    func createDailyBriefing(kidID: Int, for date: Date) async {
        guard generatingKidID == nil, refiningBriefingID == nil else { return }
        generatingKidID = kidID
        defer { generatingKidID = nil }

        let dateString = formattedDate(date)
        guard (try? await service.createDailyBriefing(kidID: kidID, date: dateString)) != nil else {
            return
        }
        await fetchDailyBriefings(for: date)
    }

    func updateDailyBriefing(briefingID: Int, instruction: String) async {
        guard generatingKidID == nil, refiningBriefingID == nil else { return }
        guard !instruction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        refiningBriefingID = briefingID
        defer { refiningBriefingID = nil }

        guard let message = try? await service.updateDailyBriefing(
            briefingID: briefingID,
            instruction: instruction
        ) else { return }
        guard var briefing,
              let index = briefing.kids.firstIndex(where: { $0.briefing?.id == message.id })
        else { return }
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
