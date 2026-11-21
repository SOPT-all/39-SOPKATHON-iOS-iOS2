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
}
