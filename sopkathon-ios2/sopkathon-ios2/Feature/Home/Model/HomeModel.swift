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
    let records: [CareRecordModel]
}

struct HomeChildModel: Identifiable {
    let id: Int
    let name: String
}
