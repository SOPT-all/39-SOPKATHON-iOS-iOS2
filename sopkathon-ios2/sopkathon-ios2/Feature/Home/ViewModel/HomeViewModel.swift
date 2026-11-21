//
//  HomeViewModel.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import Foundation
import Observation

@Observable
final class HomeViewModel {
    private(set) var home: HomeModel?

    private let service: any HomeServiceProtocol

    init(service: any HomeServiceProtocol) {
        self.service = service
    }

    var todayText: String {
        Self.dateFormatter.string(from: Date())
    }

    func fetchHome() async {
        guard let home = try? await service.fetchHome() else { return }
        self.home = HomeModel(
            teacherName: home.teacherName,
            children: home.children.shuffled(),
            records: home.records.sorted {
                ($0.recordedAt ?? .distantPast) > ($1.recordedAt ?? .distantPast)
            }
        )
    }

    func timeText(for date: Date?) -> String {
        guard let date else { return "" }
        return Self.timeFormatter.string(from: date)
    }

    func childIndex(of childID: Int) -> Int? {
        home?.children.firstIndex { $0.id == childID }
    }
}

private extension HomeViewModel {
    static let dateFormatter = makeFormatter(format: "M월 d일 EEEE")
    static let timeFormatter = makeFormatter(format: "a h:mm")

    static func makeFormatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = format
        return formatter
    }
}
