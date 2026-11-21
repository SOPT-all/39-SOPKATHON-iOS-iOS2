//
//  ProfileColor.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

enum ProfileColor: CaseIterable {
    case blue
    case yellow
    case green
    case lavender

    init(childID: Int) {
        let colors = Self.allCases
        self = colors[Int(childID.magnitude % UInt(colors.count))]
    }

    var background: Color {
        switch self {
        case .blue:
            return .pointBlue100
        case .yellow:
            return .pointYellow100
        case .green:
            return .pointGreen100
        case .lavender:
            return .pointLavender100
        }
    }

    var foreground: Color {
        switch self {
        case .blue:
            return .pointBlue200
        case .yellow:
            return .pointYellow200
        case .green:
            return .pointGreen200
        case .lavender:
            return .pointLavender200
        }
    }
}
