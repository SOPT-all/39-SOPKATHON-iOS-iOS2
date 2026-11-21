//
//  FullWidthButton.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

struct FullWidthButton: View {
    private let title: String
    private let appearance: ButtonAppearance
    private let size: ButtonSize
    private let textStyle: Typography
    private let isEnabled: Bool
    private let action: () -> Void

    init(
        title: String,
        appearance: ButtonAppearance = .primary,
        size: ButtonSize = .large,
        textStyle: Typography = .subHeader2,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.appearance = appearance
        self.size = size
        self.textStyle = textStyle
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(
            AppButtonStyle(appearance: appearance, size: size, textStyle: textStyle)
        )
        .disabled(!isEnabled)
    }
}
