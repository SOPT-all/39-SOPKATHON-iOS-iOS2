//
//  MultiLineTextField.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

struct MultiLineTextField: View {
    @Binding private var text: String

    private let title: String?
    private let placeholder: String

    init(
        title: String? = nil,
        text: Binding<String>,
        placeholder: String = ""
    ) {
        _text = text
        self.title = title
        self.placeholder = placeholder
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Metric.spacing) {
            if let title {
                Text(title)
                    .typography(.caption2)
                    .foregroundStyle(.textBlack)
            }

            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .font(Typography.body5.font)
                    .foregroundStyle(.textBlack)
                    .scrollContentBackground(.hidden)

                if text.isEmpty {
                    placeholderText
                }
            }
            .padding(.horizontal, Metric.horizontalPadding)
            .padding(.vertical, Metric.verticalPadding)
            .frame(height: Metric.height)
            .background(.baseWhite)
            .clipShape(RoundedRectangle(cornerRadius: Metric.cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: Metric.cornerRadius)
                    .stroke(.gray300, lineWidth: Metric.borderWidth)
            }
        }
    }

    private var placeholderText: some View {
        Text(placeholder)
            .font(Typography.body5.font)
            .foregroundStyle(.disabled200)
            .padding(.top, Metric.placeholderTopPadding)
            .padding(.leading, Metric.placeholderLeadingPadding)
            .allowsHitTesting(false)
    }
}

private enum Metric {
    static let spacing: CGFloat = 8
    static let height: CGFloat = 176
    static let horizontalPadding: CGFloat = 14
    static let verticalPadding: CGFloat = 10
    static let cornerRadius: CGFloat = 25
    static let borderWidth: CGFloat = 1
    static let placeholderTopPadding: CGFloat = 8
    static let placeholderLeadingPadding: CGFloat = 5
}
