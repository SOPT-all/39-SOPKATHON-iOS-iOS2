//
//  BriefingModel.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

import Foundation

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

    var briefingContent: String? {
        briefing.map { BriefingNameFormatter.resolve($0.content, childName: name) }
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

private enum BriefingNameFormatter {
    static func resolve(_ content: String, childName: String) -> String {
        let hasFinalConsonant = childName.unicodeScalars.last.map { scalar in
            (0xAC00...0xD7A3).contains(scalar.value)
                && (scalar.value - 0xAC00) % 28 != 0
        } ?? false

        return content
            .replacingOccurrences(
                of: "{childName}은(는)",
                with: childName + (hasFinalConsonant ? "은" : "는")
            )
            .replacingOccurrences(
                of: "{childName}이(가)",
                with: childName + (hasFinalConsonant ? "이" : "가")
            )
            .replacingOccurrences(
                of: "{childName}을(를)",
                with: childName + (hasFinalConsonant ? "을" : "를")
            )
            .replacingOccurrences(
                of: "{childName}과(와)",
                with: childName + (hasFinalConsonant ? "과" : "와")
            )
            .replacingOccurrences(of: "{childName}", with: childName)
    }
}
