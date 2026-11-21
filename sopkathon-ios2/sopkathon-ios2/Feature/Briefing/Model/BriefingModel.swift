//
//  BriefingModel.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

struct BriefingModel {
    let date: String
    let recordedKidNames: [String]
    var kids: [BriefingKidModel]
}

struct BriefingKidModel: Identifiable {
    let id: Int
    let name: String
    let age: Int
    let recordCount: Int
    let summary: [BriefingSummaryItemModel]
    let parent: BriefingParentModel?
    var briefing: BriefingMessageModel?

    var summaryRows: [[BriefingSummaryItemModel]] {
        stride(from: 0, to: summary.count, by: 2).map { index in
            Array(summary[index..<min(index + 2, summary.count)])
        }
    }
}

struct BriefingSummaryItemModel {
    let category: CareRecordCategoryModel
    let count: Int
}

struct BriefingParentModel {
    let name: String
    let phone: String
}

struct BriefingMessageModel {
    let id: Int
    let content: String
}
