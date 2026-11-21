//
//  InputFieldContainer.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

struct InputFieldContainer<Content: View>: View {
    private let title: String?
    private let errorMessage: String?
    private let isFocused: Bool
    private let content: Content

    init(
        title: String?,
        errorMessage: String? = nil,
        isFocused: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.errorMessage = errorMessage
        self.isFocused = isFocused
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Metric.spacing) {
            if let title {
                Text(title)
                    .typography(.caption2)
                    .foregroundStyle(.textBlack)
            }

            content
                .padding(.horizontal, Metric.horizontalPadding)
                .background(.gray50)
                .clipShape(RoundedRectangle(cornerRadius: Metric.cornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: Metric.cornerRadius)
                        .strokeBorder(borderColor, lineWidth: Metric.borderWidth)
                }

            if let errorMessage {
                Text(errorMessage)
                    .typography(.caption3)
                    .foregroundStyle(Color(.systemRed))
            }
        }
    }

    private var borderColor: Color {
        if errorMessage != nil {
            return Color(.systemRed)
        }
        return isFocused ? .gray200 : .clear
    }
}

private enum Metric {
    static let spacing: CGFloat = 8
    static let horizontalPadding: CGFloat = 12
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 1
}
