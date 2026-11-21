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

    private let service: any BriefingServiceProtocol

    init(service: any BriefingServiceProtocol) {
        self.service = service
    }

    func fetchDailyBriefings(for date: Date) async {
        let dateString = formattedDate(date)
        guard let briefing = try? await service.fetchDailyBriefings(date: dateString) else { return }
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
