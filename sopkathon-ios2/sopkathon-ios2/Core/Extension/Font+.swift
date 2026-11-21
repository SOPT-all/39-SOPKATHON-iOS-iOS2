//
//  Font+.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

enum PretendardWeight: String {
    case regular = "Pretendard-Regular"
    case medium = "Pretendard-Medium"
    case semiBold = "Pretendard-SemiBold"
    case bold = "Pretendard-Bold"

    static let defaultLineHeightRatio: CGFloat = 1.193
}

enum Typography: CaseIterable {
    case header1
    case header2
    case header3

    case subHeader1
    case subHeader2

    case body1
    case body2
    case body3
    case body4
    case body5

    case caption1
    case caption2
    case caption3

    var weight: PretendardWeight {
        switch self {
        case .header1, .header3:
            .bold
        case .header2, .subHeader1, .body2, .body4, .caption2:
            .semiBold
        case .subHeader2, .body1, .caption3:
            .medium
        case .body3, .body5, .caption1:
            .regular
        }
    }

    var size: CGFloat {
        switch self {
        case .header1, .header2: 24
        case .header3: 20
        case .subHeader1: 18
        case .subHeader2, .body1, .body2, .body3: 16
        case .caption1: 15
        case .body4, .body5, .caption2: 14
        case .caption3: 13
        }
    }

    var lineHeight: CGFloat {
        switch self {
        case .header1, .header2: 28
        case .subHeader1: 26
        case .header3, .subHeader2, .body1, .body2, .body3: 24
        case .body4, .body5: 20
        case .caption1, .caption2, .caption3: 16
        }
    }

    var font: Font {
        .custom(weight.rawValue, size: size)
    }

    var extraLineSpacing: CGFloat {
        let defaultLineHeight = size * PretendardWeight.defaultLineHeightRatio
        return max(lineHeight - defaultLineHeight, 0)
    }
}

struct TypographyModifier: ViewModifier {
    let style: Typography

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .lineSpacing(style.extraLineSpacing)
            .padding(.vertical, style.extraLineSpacing / 2)
    }
}

extension View {
    func typography(_ style: Typography) -> some View {
        modifier(TypographyModifier(style: style))
    }
}

extension Font {
    static func pretendard(_ weight: PretendardWeight, size: CGFloat) -> Font {
        .custom(weight.rawValue, size: size)
    }
}
