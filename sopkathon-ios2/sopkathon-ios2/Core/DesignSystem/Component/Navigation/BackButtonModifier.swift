//
//  BackButtonModifier.swift
//  sopkathon-ios2
//
//  Created by bomin on 11/22/26.
//

import SwiftUI

struct BackButtonModifier: ViewModifier {
    private let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                if #available(iOS 26.0, *) {
                    ToolbarItem(placement: .topBarLeading) {
                        backButtonView
                    }
                    .sharedBackgroundVisibility(.hidden)
                } else {
                    ToolbarItem(placement: .topBarLeading) {
                        backButtonView
                    }
                }
            }
    }

    private var backButtonView: some View {
        Button(action: action) {
            Image(.iconBack)
                .frame(width: Metric.iconSize, height: Metric.iconSize)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private enum Metric {
    static let iconSize: CGFloat = 24
}
