//
//  MockCareRecordService.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import Foundation

struct MockCareRecordService {}

extension MockCareRecordService: CareRecordServiceProtocol {
    func createCareRecords(_ draft: CareRecordDraftModel) async throws -> [CareRecordModel] {
        guard let childID = draft.childID else {
            return [
                CareRecordModel(
                    id: 11,
                    childID: 1,
                    childName: "김지우",
                    category: .feeding,
                    recordedAt: .now
                ),
                CareRecordModel(
                    id: 12,
                    childID: 2,
                    childName: "이하준",
                    category: .sleep,
                    recordedAt: .now
                )
            ]
        }

        return [
            CareRecordModel(
                id: 11,
                childID: childID,
                childName: "김지우",
                category: draft.category,
                recordedAt: .now
            )
        ]
    }
}
