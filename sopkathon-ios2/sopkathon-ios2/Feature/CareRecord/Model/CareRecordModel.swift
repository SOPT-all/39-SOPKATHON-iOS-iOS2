//
//  CareRecordModel.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import Foundation

struct CareRecordModel: Identifiable {
    let id: Int
    let childID: Int
    let childName: String
    let category: CareRecordCategoryModel?
    let recordedAt: Date?
}

struct CareRecordDraftModel {
    var childID: Int?
    var category: CareRecordCategoryModel?
    var text: String
}

enum CareRecordCategoryModel: CaseIterable {
    case feeding
    case play
    case meal
    case diaper
    case sleep
    case health

    var title: String {
        switch self {
        case .feeding:
            return "수유"
        case .meal:
            return "식사"
        case .sleep:
            return "수면"
        case .diaper:
            return "배변"
        case .play:
            return "놀이"
        case .health:
            return "건강"
        }
    }

    static func mentioned(in text: String) -> CareRecordCategoryModel? {
        allCases
            .compactMap { category -> (category: Self, position: String.Index)? in
                let positions = category.keywords.compactMap { text.range(of: $0)?.lowerBound }
                guard let position = positions.min() else { return nil }
                return (category, position)
            }
            .min { $0.position < $1.position }?
            .category
    }

    private var keywords: [String] {
        switch self {
        case .feeding:
            return ["분유", "우유", "수유", "젖병", "모유"]
        case .meal:
            return ["밥", "점심", "아침", "저녁", "간식", "식사", "이유식", "먹"]
        case .sleep:
            return ["낮잠", "잤", "자고", "잠들", "잠을", "수면", "재웠"]
        case .diaper:
            return ["기저귀", "응가", "대변", "소변", "배변", "똥", "쉬했", "쉬를"]
        case .play:
            return ["놀았", "놀고", "놀이", "장난감", "블록", "산책", "그림"]
        case .health:
            return [
                "열이", "열나", "기침", "약을", "약 ", "콧물",
                "아파", "아프", "다쳤", "병원", "체온", "토했"
            ]
        }
    }
}
