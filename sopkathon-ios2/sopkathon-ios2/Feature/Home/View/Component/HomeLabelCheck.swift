//
//  HomeLabelCheck.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import SwiftUI

struct HomeLabelCheck: View {
    enum Category {
        case feeding
        case meal
        case sleep
        case play
        case toilet
        case health

        var title: String {
            switch self {
            case .feeding:
                return "수유"
            case .meal:
                return "식사"
            case .sleep:
                return "수면"
            case .play:
                return "놀이"
            case .toilet:
                return "배변"
            case .health:
                return "건강"
            }
        }
    }

    private let category: Category

    init(category: Category) {
        self.category = category
    }

    var body: some View {
        HStack(spacing: Metric.spacing) {
            Text(category.title)
                .typography(.caption2)
                .foregroundStyle(.baseWhite)

            Image(.labelCheck)
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
