//
//  NavigationHeader.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

struct NavigationHeader: View {
    @Environment(\.dismiss) private var dismiss

    private let title: String
    private let onBack: (() -> Void)?
    private let style: NavigationHeaderStyle

    init(
        title: String,
        style: NavigationHeaderStyle,
        onBack: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.onBack = onBack
    }

    var body: some View {
        Text(title)
            .font(Typography.subHeader1.font)
            .foregroundStyle(.textBlack)
            .frame(maxWidth: .infinity)
            .frame(height: Metric.height)
            .overlay(alignment: .leading) {
                Button {
                    if let onBack {
                        onBack()
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(.iconBack)
                        .frame(width: Metric.height, height: Metric.height)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, style.horizontalPadding)
            .padding(.top, style.topPadding)
            .padding(.bottom, style.bottomPadding)
            .background {
                if style.hasBackground {
                    backgroundView
                }
            }
            .zIndex(Metric.zIndex)
    }

    private var backgroundView: some View {
        Color.baseWhite
            .shadow(
                color: .baseShadow.opacity(Metric.shadowOpacity),
                radius: Metric.shadowRadius,
                y: Metric.shadowOffsetY
            )
            .ignoresSafeArea(edges: .top)
    }
}

private extension NavigationHeader {
    enum Metric {
        static let height: CGFloat = 24
        static let shadowOpacity: Double = 0.1
        static let shadowRadius: CGFloat = 2
        static let shadowOffsetY: CGFloat = 4
        static let zIndex: Double = 1
    }
}
