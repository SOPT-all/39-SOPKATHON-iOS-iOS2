//
//  CategoryChip.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

struct CategoryChip: View {
    private let category: CareRecordCategoryModel

    init(category: CareRecordCategoryModel) {
        self.category = category
    }

    var body: some View {
        HStack(spacing: Metric.spacing) {
            Image(category.icon)
                .resizable()
                .scaledToFit()
                .frame(width: Metric.iconSize, height: Metric.iconSize)

            Text(category.title)
                .font(Typography.caption2.font)
                .foregroundStyle(.textBlack)
        }
        .padding(.horizontal, Metric.horizontalPadding)
        .frame(height: Metric.height)
        .background(.gray50)
        .clipShape(Capsule())
    }
}

private extension CategoryChip {
    enum Metric {
        static let height: CGFloat = 38
        static let horizontalPadding: CGFloat = 13
        static let spacing: CGFloat = 10
        static let iconSize: CGFloat = 20
    }
}
