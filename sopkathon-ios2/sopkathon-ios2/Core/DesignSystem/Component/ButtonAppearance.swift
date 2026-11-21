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

    func backgroundColor(isEnabled: Bool, isPressed: Bool) -> Color {
        guard isEnabled else { return Color(.systemGray5) }

        let color: Color
        switch self {
        case .primary:
            color = .accentColor
        case .secondary:
            color = .clear
        case .destructive:
            color = Color(.systemRed).opacity(Opacity.destructiveBackground)
        }
        return isPressed ? color.opacity(Opacity.pressed) : color
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
    static let pressed: Double = 0.7
}
