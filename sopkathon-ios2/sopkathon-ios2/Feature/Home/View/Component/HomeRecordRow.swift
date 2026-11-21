//
//  HomeRecordRow.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import SwiftUI

struct HomeRecordRow: View {
    private let childID: Int
    private let name: String
    private let time: String
    private let category: CareRecordCategoryModel

    init(
        childID: Int,
        name: String,
        time: String,
        category: CareRecordCategoryModel
    ) {
        self.childID = childID
        self.name = name
        self.time = time
        self.category = category
    }

    var body: some View {
        HStack(spacing: Metric.spacing) {
            ProfileCard(childID: childID, name: name, size: .small)

            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .typography(.caption2)
                    .frame(height: Metric.nameHeight)

                Text(time)
                    .typography(.body5)
                    .frame(height: Metric.timeHeight)
            }
            .foregroundStyle(.textBlack)

            Spacer()

            HomeLabelCheck(category: category)
        }
        .frame(height: Metric.height)
    }
}

private enum Metric {
    static let height: CGFloat = 42
    static let spacing: CGFloat = 8
    static let nameHeight: CGFloat = 23
    static let timeHeight: CGFloat = 18
}
