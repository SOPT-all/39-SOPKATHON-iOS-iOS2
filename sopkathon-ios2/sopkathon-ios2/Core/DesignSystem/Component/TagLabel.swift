//
//  TagLabel.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

struct TagLabel: View {
    enum Appearance {
        case primary
        case gray

        var foregroundColor: Color {
            switch self {
            case .primary:
                return .accentColor
            case .gray:
                return Color(.systemGray)
            }
        }

        var backgroundColor: Color {
            switch self {
            case .primary:
                return .accentColor.opacity(0.12)
            case .gray:
                return Color(.systemGray6)
            }
        }
    }

    private let text: String
    private let appearance: Appearance

    init(text: String, appearance: Appearance = .primary) {
        self.text = text
        self.appearance = appearance
    }

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(appearance.foregroundColor)
            .padding(.horizontal, Metric.horizontalPadding)
            .padding(.vertical, Metric.verticalPadding)
            .background(appearance.backgroundColor)
            .clipShape(Capsule())
    }
}

private extension TagLabel {
    enum Metric {
        static let horizontalPadding: CGFloat = 8
        static let verticalPadding: CGFloat = 4
    }
}
