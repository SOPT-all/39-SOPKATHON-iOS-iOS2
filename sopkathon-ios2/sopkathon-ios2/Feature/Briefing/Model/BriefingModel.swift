//
//  BriefingModel.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

struct BriefingModel {
    let date: String
    let recordedKidCount: Int
    let kids: [BriefingKidModel]
}

struct BriefingKidModel: Identifiable {
    let id: Int
    let name: String
    let age: Int
    let recordCount: Int
    let summary: BriefingSummaryModel
    let parent: BriefingParentModel
    let briefing: BriefingMessageModel?
}

struct BriefingSummaryModel {
    let feeding: Int
    let sleep: Int
    let diaper: Int
}

struct BriefingParentModel {
    let name: String
    let phone: String
}

struct BriefingMessageModel {
    let id: Int
    let content: String
}
