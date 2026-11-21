//
//  ProfileCard.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

struct ProfileCard: View {
    private let childID: Int
    private let name: String
    private let size: ProfileCardSize

    init(
        childID: Int,
        name: String,
        size: ProfileCardSize = .small
    ) {
        self.childID = childID
        self.name = name
        self.size = size
    }

    var body: some View {
        let color = ProfileColor(childID: childID)

        Text(initial)
            .font(.pretendard(.bold, size: size.fontSize))
            .foregroundStyle(color.foreground)
            .frame(width: size.length, height: size.length)
            .background(color.background)
            .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
    }

    private var initial: String {
        guard let character = name.dropFirst().first ?? name.first else { return "" }
        return String(character)
    }
}

enum ProfileCardSize {
    case small
    case medium
    case large
    case extraLarge

    var length: CGFloat {
        switch self {
        case .small:
            return 41
        case .medium:
            return 48
        case .large:
            return 70
        case .extraLarge:
            return 90
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .small, .medium:
            return 16
        case .large:
            return 25
        case .extraLarge:
            return 32.5
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .small:
            return 20
        case .medium:
            return 24
        case .large:
            return 35
        case .extraLarge:
            return 45
        }
    }
}
