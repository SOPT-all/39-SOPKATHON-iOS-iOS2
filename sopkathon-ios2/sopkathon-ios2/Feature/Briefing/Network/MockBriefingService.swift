//
//  MockBriefingService.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

final class MockBriefingService {
    private var generatedMessagesByDate: [String: [Int: BriefingMessageModel]] = [:]
    private var lastFetchedDate: String?

    private enum MockBriefingError: Error {
        case missingDate
    }
}

extension MockBriefingService: BriefingServiceProtocol {
    func fetchDailyBriefings(date: String) async throws -> BriefingModel {
        lastFetchedDate = date

        return BriefingModel(
            date: date,
            recordedKidCount: 2,
            kids: [
                BriefingKidModel(
                    id: 1,
                    name: "김지우",
                    age: 2,
                    recordCount: 6,
                    summary: BriefingSummaryModel(feeding: 3, sleep: 1, diaper: 2),
                    parent: BriefingParentModel(name: "김OO", phone: "010-1234-5678"),
                    briefing: generatedMessagesByDate[date]?[1] ?? BriefingMessageModel(
                        id: 5,
                        content: "지우는 오늘 수유 3회, 낮잠 1회, "
                            + "기저귀 교체 2회를 했어요."
                    )
                ),
                BriefingKidModel(
                    id: 2,
                    name: "이하준",
                    age: 3,
                    recordCount: 2,
                    summary: BriefingSummaryModel(feeding: 1, sleep: 1, diaper: 0),
                    parent: BriefingParentModel(name: "이OO", phone: "010-5678-1234"),
                    briefing: generatedMessagesByDate[date]?[2]
                )
            ]
        )
    }

    func createDailyBriefing(kidID: Int, date: String) async throws -> BriefingMessageModel {
        let message = BriefingMessageModel(
            id: kidID + 4,
            content: "오늘의 돌봄 기록을 바탕으로 브리핑을 생성했어요."
        )
        generatedMessagesByDate[date, default: [:]][kidID] = message
        return message
    }

    func updateDailyBriefing(
        briefingID: Int,
        instruction: String
    ) async throws -> BriefingMessageModel {
        guard let lastFetchedDate else { throw MockBriefingError.missingDate }
        let kidID = briefingID - 4
        let message = BriefingMessageModel(
            id: briefingID,
            content: "\(instruction) 요청을 반영해 브리핑을 다듬었어요."
        )
        generatedMessagesByDate[lastFetchedDate, default: [:]][kidID] = message
        return message
    }
}
