//
//  CategoryChip.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

struct CategoryChip: View {
    private let category: CareRecordCategoryModel
    private let isSelected: Bool

    init(category: CareRecordCategoryModel, isSelected: Bool = false) {
        self.category = category
        self.isSelected = isSelected
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
        .background(isSelected ? Color.primary50 : Color.gray50)
        .clipShape(Capsule())
        .overlay {
            if isSelected {
                Capsule()
                    .stroke(.primary400, lineWidth: Metric.selectedBorderWidth)
            }
        }
    }
}

private extension CategoryChip {
    enum Metric {
        static let height: CGFloat = 38
        static let horizontalPadding: CGFloat = 13
        static let spacing: CGFloat = 10
        static let iconSize: CGFloat = 20
        static let selectedBorderWidth: CGFloat = 1.5
    }
}
