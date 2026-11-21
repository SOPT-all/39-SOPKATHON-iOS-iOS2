//
//  CompactButton.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

struct CompactButton: View {
    private let title: String
    private let appearance: ButtonAppearance
    private let size: ButtonSize
    private let isEnabled: Bool
    private let action: () -> Void

    init(
        title: String,
        appearance: ButtonAppearance = .primary,
        size: ButtonSize = .small,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.appearance = appearance
        self.size = size
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, Metric.horizontalPadding)
        }
        .buttonStyle(AppButtonStyle(appearance: appearance, size: size))
        .disabled(!isEnabled)
    }
}

private extension CompactButton {
    enum Metric {
        static let horizontalPadding: CGFloat = 26
    }
}
