//
//  MockHomeService.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import Foundation

struct MockHomeService {}

extension MockHomeService: HomeServiceProtocol {
    func fetchHome() async throws -> HomeModel {
        HomeModel(
            teacherName: "한미녀 선생님",
            unrecordedChildren: [
                HomeChildModel(id: 1, name: "이우진"),
                HomeChildModel(id: 2, name: "조은하"),
                HomeChildModel(id: 3, name: "김현지"),
                HomeChildModel(id: 4, name: "박지안")
            ],
            records: [
                HomeRecordModel(
                    id: 1,
                    childName: "이우진",
                    colorID: 1,
                    category: .feeding,
                    recordedAt: .now.addingTimeInterval(-3600)
                ),
                HomeRecordModel(
                    id: 2,
                    childName: "조은하",
                    colorID: 2,
                    category: .sleep,
                    recordedAt: .now
                ),
                HomeRecordModel(
                    id: 3,
                    childName: "김현지",
                    colorID: 3,
                    category: .diaper,
                    recordedAt: .now.addingTimeInterval(-7200)
                ),
                HomeRecordModel(
                    id: 4,
                    childName: "박지안",
                    colorID: 0,
                    category: .meal,
                    recordedAt: .now.addingTimeInterval(-10800)
                )
            ]
        )
    }
}
