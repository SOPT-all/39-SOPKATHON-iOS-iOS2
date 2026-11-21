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

    init(appearance: ButtonAppearance, size: ButtonSize) {
        self.appearance = appearance
        self.size = size
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typography(.subHeader2)
            .foregroundStyle(appearance.foregroundColor(isEnabled: isEnabled))
            .frame(height: size.height)
            .background(
                appearance.backgroundColor(
                    isEnabled: isEnabled,
                    isPressed: configuration.isPressed
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: Metric.cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: Metric.cornerRadius)
                    .stroke(
                        appearance.borderColor(isEnabled: isEnabled),
                        lineWidth: Metric.borderWidth
                    )
            }
    }
}

private enum Metric {
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 1
}
