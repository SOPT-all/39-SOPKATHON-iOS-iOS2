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
        guard isEnabled else { return .baseWhite }

        switch self {
        case .primary, .secondary:
            return .baseWhite
        case .destructive:
            return Color(.systemRed)
        }
    }

    func backgroundColor(isEnabled: Bool, isPressed: Bool) -> Color {
        guard isEnabled else { return .disabled50 }

        switch self {
        case .primary:
            return isPressed ? .primary600 : .primary400
        case .secondary:
            return isPressed ? .disabled100 : .gray300
        case .destructive:
            let color = Color(.systemRed).opacity(Opacity.destructiveBackground)
            return isPressed ? color.opacity(Opacity.pressed) : color
        }
    }
}

private enum Opacity {
    static let destructiveBackground: Double = 0.15
    static let pressed: Double = 0.7
}
