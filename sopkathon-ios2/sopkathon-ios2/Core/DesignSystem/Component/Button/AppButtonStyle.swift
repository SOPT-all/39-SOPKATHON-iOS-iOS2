//
//  AppButtonStyle.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import SwiftUI

struct AppButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    private let appearance: ButtonAppearance
    private let size: ButtonSize
    private let textStyle: Typography

    init(
        appearance: ButtonAppearance,
        size: ButtonSize,
        textStyle: Typography = .subHeader2
    ) {
        self.appearance = appearance
        self.size = size
        self.textStyle = textStyle
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typography(textStyle)
            .foregroundStyle(.baseWhite)
            .frame(height: size.height)
            .background(
                appearance.backgroundColor(
                    isEnabled: isEnabled,
                    isPressed: configuration.isPressed
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: Metric.cornerRadius))
    }
}

private enum Metric {
    static let cornerRadius: CGFloat = 10
}
