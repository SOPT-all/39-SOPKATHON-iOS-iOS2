//
//  HomeMemoCard.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import SwiftUI

struct HomeMemoCard: View {
    private let kind: HomeMemoCardKind
    private let action: () -> Void

    init(kind: HomeMemoCardKind, action: @escaping () -> Void) {
        self.kind = kind
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: kind.spacing) {
                Image(kind.icon)
                    .resizable()
                    .frame(width: Metric.iconSize, height: Metric.iconSize)

                Text(kind.title)
                    .typography(.subHeader1)
                    .foregroundStyle(kind.titleColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: Metric.height)
            .background(kind.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Metric.cornerRadius))
            .shadow(
                color: .baseBlack.opacity(kind.shadowOpacity),
                radius: Metric.shadowRadius
            )
        }
        .buttonStyle(.plain)
    }
}

private enum Metric {
    static let height: CGFloat = 111
    static let cornerRadius: CGFloat = 28
    static let iconSize: CGFloat = 34
    static let shadowRadius: CGFloat = 4.5
}
