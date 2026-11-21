//
//  HomeModel.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import Foundation

struct HomeModel {
    let teacherName: String
    let unrecordedChildren: [HomeChildModel]
    let records: [HomeRecordModel]
}

struct HomeChildModel: Identifiable {
    let id: Int
    let name: String
}

struct HomeRecordModel: Identifiable {
    let id: Int
    let childName: String
    let colorID: Int
    let category: CareRecordCategoryModel
    let recordedAt: Date
}
