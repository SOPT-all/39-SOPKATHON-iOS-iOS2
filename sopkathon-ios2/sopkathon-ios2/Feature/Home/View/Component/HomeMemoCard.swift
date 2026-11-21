//
//  HomeMemoCard.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import SwiftUI

struct HomeMemoCard: View {
    enum Kind {
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

    private let kind: Kind
    private let action: () -> Void

    init(kind: Kind, action: @escaping () -> Void) {
        self.kind = kind
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: kind.spacing) {
                Image(kind.icon)
                    .resizable()
                    .frame(width: Metric.iconSize, height: Metric.iconSize)

                Text(kind.title)
                    .typography(.subHeader1)
                    .foregroundStyle(kind.titleColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: Metric.height)
            .background(kind.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Metric.cornerRadius))
            .shadow(
                color: .baseBlack.opacity(kind.shadowOpacity),
                radius: Metric.shadowRadius
            )
        }
        .buttonStyle(.plain)
    }
}

private enum Metric {
    static let height: CGFloat = 111
    static let cornerRadius: CGFloat = 28
    static let iconSize: CGFloat = 34
    static let shadowRadius: CGFloat = 4.5
}
