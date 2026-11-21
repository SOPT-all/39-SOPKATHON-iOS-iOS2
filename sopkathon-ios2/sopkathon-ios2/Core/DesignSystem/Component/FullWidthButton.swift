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
    private let isEnabled: Bool
    private let action: () -> Void

    init(
        title: String,
        appearance: ButtonAppearance = .primary,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.appearance = appearance
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .typography(.h1Sb16)
                .foregroundStyle(appearance.foregroundColor(isEnabled: isEnabled))
                .frame(maxWidth: .infinity)
                .frame(height: Metric.height)
                .background(appearance.backgroundColor(isEnabled: isEnabled))
                .clipShape(RoundedRectangle(cornerRadius: Metric.cornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: Metric.cornerRadius)
                        .stroke(
                            appearance.borderColor(isEnabled: isEnabled),
                            lineWidth: Metric.borderWidth
                        )
                }
        }
        .disabled(!isEnabled)
    }
}

private extension FullWidthButton {
    enum Metric {
        static let height: CGFloat = 52
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 1
    }
}
