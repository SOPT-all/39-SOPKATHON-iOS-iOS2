//
//  ButtonAppearance.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

enum ButtonAppearance {
    case primary
    case secondary
    case destructive

    func foregroundColor(isEnabled: Bool) -> Color {
        guard isEnabled else { return Color(.systemGray) }

        switch self {
        case .primary:
            return .white
        case .secondary:
            return .accentColor
        case .destructive:
            return Color(.systemRed)
        }
    }

    func backgroundColor(isEnabled: Bool) -> Color {
        guard isEnabled else { return Color(.systemGray5) }

        switch self {
        case .primary:
            return .accentColor
        case .secondary:
            return .clear
        case .destructive:
            return Color(.systemRed).opacity(Opacity.destructiveBackground)
        }
    }

    func borderColor(isEnabled: Bool) -> Color {
        guard isEnabled else { return .clear }

        switch self {
        case .primary, .destructive:
            return .clear
        case .secondary:
            return .accentColor
        }
    }
}

private enum Opacity {
    static let destructiveBackground: Double = 0.15
}
