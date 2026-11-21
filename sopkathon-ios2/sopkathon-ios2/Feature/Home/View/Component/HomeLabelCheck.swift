//
//  HomeLabelCheck.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import SwiftUI

struct HomeLabelCheck: View {
    private let category: CareRecordCategoryModel

    init(category: CareRecordCategoryModel) {
        self.category = category
    }

    var body: some View {
        HStack(spacing: Metric.spacing) {
            Text(category.title)
                .typography(.caption2)
                .foregroundStyle(.baseWhite)

            Image(.iconLabelCheck)
                .resizable()
                .frame(width: Metric.iconSize, height: Metric.iconSize)
        }
        .padding(.horizontal, Metric.horizontalPadding)
        .frame(height: Metric.height)
        .background(.pointMint100)
        .clipShape(Capsule())
    }
}

private enum Metric {
    static let height: CGFloat = 42
    static let horizontalPadding: CGFloat = 8
    static let spacing: CGFloat = 3
    static let iconSize: CGFloat = 27
}
