//
//  HomeProfileCard.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import SwiftUI

struct HomeProfileCard: View {
    enum Palette {
        case lavender
        case yellow
        case green
        case blue

        var backgroundColor: Color {
            switch self {
            case .lavender:
                return .pointLavender100
            case .yellow:
                return .pointYellow100
            case .green:
                return .pointGreen100
            case .blue:
                return .pointBlue100
            }
        }

        var textColor: Color {
            switch self {
            case .lavender:
                return .pointLavender200
            case .yellow:
                return .pointYellow200
            case .green:
                return .pointGreen200
            case .blue:
                return .pointBlue200
            }
        }
    }

    enum Size {
        case large
        case small

        var width: CGFloat {
            switch self {
            case .large:
                return 70
            case .small:
                return 41
            }
        }

        var height: CGFloat {
            switch self {
            case .large:
                return 70
            case .small:
                return 42
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .large:
                return 25
            case .small:
                return 15
            }
        }

        var fontSize: CGFloat {
            switch self {
            case .large:
                return 35
            case .small:
                return 20
            }
        }
    }

    private let name: String
    private let palette: Palette
    private let size: Size

    init(name: String, palette: Palette, size: Size = .large) {
        self.name = name
        self.palette = palette
        self.size = size
    }

    var body: some View {
        Text(initial)
            .font(.pretendard(.bold, size: size.fontSize))
            .foregroundStyle(palette.textColor)
            .frame(width: size.width, height: size.height)
            .background(palette.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
    }

    private var initial: String {
        let givenName = name.count > 1 ? name.dropFirst() : Substring(name)
        return givenName.first.map(String.init) ?? ""
    }
}
