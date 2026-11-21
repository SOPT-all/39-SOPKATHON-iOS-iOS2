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

    func backgroundColor(isEnabled: Bool, isPressed: Bool) -> Color {
        guard isEnabled else { return .disabled50 }

        switch self {
        case .primary:
            return isPressed ? .primary600 : .primary400
        case .secondary:
            return isPressed ? .disabled100 : .gray300
        }
    }
}
