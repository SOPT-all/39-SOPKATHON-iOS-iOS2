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

    func foregroundColor(isEnabled: Bool) -> Color {
        guard isEnabled else { return Color(.systemGray) }

        switch self {
        case .primary:
            return .white
        case .secondary:
            return .accentColor
        }
    }

    func backgroundColor(isEnabled: Bool) -> Color {
        guard isEnabled else { return Color(.systemGray5) }

        switch self {
        case .primary:
            return .accentColor
        case .secondary:
            return .clear
        }
    }

    func borderColor(isEnabled: Bool) -> Color {
        guard isEnabled else { return .clear }

        switch self {
        case .primary:
            return .clear
        case .secondary:
            return .accentColor
        }
    }
}
