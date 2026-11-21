//
//  ProfileColor.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

enum ProfileColor: CaseIterable {
    case lavender
    case yellow
    case blue
    case mint
    case green

    init(childID: Int) {
        let colors = Self.allCases
        self = colors[Int(childID.magnitude % UInt(colors.count))]
    }

    var background: Color {
        switch self {
        case .lavender:
            return .pointLavender100
        case .yellow:
            return .pointYellow100
        case .blue:
            return .pointBlue100
        case .mint:
            return .pointMint100
        case .green:
            return .pointGreen100
        }
    }

    var foreground: Color {
        switch self {
        case .lavender:
            return .pointLavender200
        case .yellow:
            return .pointYellow200
        case .blue:
            return .pointBlue200
        case .mint:
            return .pointMint200
        case .green:
            return .pointGreen200
        }
    }
}
