//
//  MultiLineTextField.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

struct MultiLineTextField: View {
    @Binding private var text: String

    @FocusState private var isFocused: Bool

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
        InputFieldContainer(title: title, isFocused: isFocused) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .typography(.body5)
                    .scrollContentBackground(.hidden)
                    .focused($isFocused)

                if text.isEmpty {
                    placeholderText
                }
            }
            .padding(.vertical, Metric.verticalPadding)
            .frame(height: Metric.height)
        }
    }

    private var placeholderText: some View {
        Text(placeholder)
            .typography(.body5)
            .foregroundStyle(Color(.placeholderText))
            .padding(.top, Metric.placeholderTopPadding)
            .padding(.leading, Metric.placeholderLeadingPadding)
            .allowsHitTesting(false)
    }
}

private enum Metric {
    static let height: CGFloat = 120
    static let verticalPadding: CGFloat = 4
    static let placeholderTopPadding: CGFloat = 8
    static let placeholderLeadingPadding: CGFloat = 5
}
