//
//  CategorySummaryChip.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

struct CategorySummaryChip: View {
    private let category: CareRecordCategoryModel
    private let summary: String

    init(category: CareRecordCategoryModel, summary: String) {
        self.category = category
        self.summary = summary
    }

    var body: some View {
        HStack(spacing: Metric.spacing) {
            Image(category.icon)
                .resizable()
                .scaledToFit()
                .frame(width: Metric.iconSize, height: Metric.iconSize)

            HStack(spacing: Metric.textSpacing) {
                Text(category.title)
                    .font(Typography.body4.font)

                Text(summary)
                    .font(Typography.body5.font)
            }
            .foregroundStyle(.textBlack)
        }
        .padding(.horizontal, Metric.horizontalPadding)
        .frame(height: Metric.height)
        .background(.primary50)
        .clipShape(RoundedRectangle(cornerRadius: Metric.cornerRadius))
    }
}

private extension CategorySummaryChip {
    enum Metric {
        static let height: CGFloat = 59
        static let horizontalPadding: CGFloat = 11
        static let cornerRadius: CGFloat = 25
        static let spacing: CGFloat = 8
        static let textSpacing: CGFloat = 6
        static let iconSize: CGFloat = 24
    }
}
