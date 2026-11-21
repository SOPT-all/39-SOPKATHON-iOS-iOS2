//
//  NavigationHeaderStyle.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import SwiftUI

enum NavigationHeaderStyle {
    case plain
    case bar

    var horizontalPadding: CGFloat {
        switch self {
        case .plain:
            return 24
        case .bar:
            return 13
        }
    }

    var topPadding: CGFloat {
        switch self {
        case .plain:
            return 17
        case .bar:
            return 33
        }
    }

    var bottomPadding: CGFloat {
        switch self {
        case .plain:
            return 0
        case .bar:
            return 18
        }
    }

    var hasBackground: Bool {
        switch self {
        case .plain:
            return false
        case .bar:
            return true
        }
    }
}
