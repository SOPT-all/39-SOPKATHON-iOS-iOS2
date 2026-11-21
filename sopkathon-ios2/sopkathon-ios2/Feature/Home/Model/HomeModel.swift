//
//  HomeModel.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import Foundation

struct HomeModel {
    let teacherName: String
    let children: [HomeChildModel]
    let records: [HomeRecordModel]
}

struct HomeChildModel: Identifiable {
    let id: Int
    let name: String
    let profileColor: HomeProfileColorModel
}

struct HomeRecordModel: Identifiable {
    let id: Int
    let childName: String
    let profileColor: HomeProfileColorModel
    let category: CareRecordCategoryModel
    let recordedAt: Date
}

enum HomeProfileColorModel: CaseIterable {
    case lavender
    case yellow
    case green
    case blue

    init(childID: Int) {
        let colors = Self.allCases
        self = colors[abs(childID) % colors.count]
    }
}
