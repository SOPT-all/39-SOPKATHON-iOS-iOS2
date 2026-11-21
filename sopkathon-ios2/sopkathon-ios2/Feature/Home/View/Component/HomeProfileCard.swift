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

    private let name: String
    private let palette: Palette

    init(name: String, palette: Palette) {
        self.name = name
        self.palette = palette
    }

    var body: some View {
        Text(initial)
            .font(.pretendard(.bold, size: Metric.fontSize))
            .foregroundStyle(palette.textColor)
            .frame(width: Metric.size, height: Metric.size)
            .background(palette.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Metric.cornerRadius))
    }

    private var initial: String {
        let givenName = name.count > 1 ? name.dropFirst() : Substring(name)
        return givenName.first.map(String.init) ?? ""
    }
}

private enum Metric {
    static let size: CGFloat = 70
    static let cornerRadius: CGFloat = 25
    static let fontSize: CGFloat = 35
}
