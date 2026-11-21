//
//  HomeMemoCardKind.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import SwiftUI

enum HomeMemoCardKind {
    case text
    case voice

    var title: String {
        switch self {
        case .text:
            return "텍스트 메모"
        case .voice:
            return "음성 메모"
        }
    }

    var icon: ImageResource {
        switch self {
        case .text:
            return .iconText
        case .voice:
            return .iconVoice
        }
    }

    var titleColor: Color {
        switch self {
        case .text:
            return .textBlack
        case .voice:
            return .baseWhite
        }
    }

    var backgroundColor: Color {
        switch self {
        case .text:
            return .baseWhite
        case .voice:
            return .primary400
        }
    }

    var spacing: CGFloat {
        switch self {
        case .text:
            return 10
        case .voice:
            return 8
        }
    }

    var shadowOpacity: Double {
        switch self {
        case .text:
            return 0.1
        case .voice:
            return 0
        }
    }
}
