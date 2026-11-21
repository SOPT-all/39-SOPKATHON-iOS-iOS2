//
//  SingleLineTextField.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

struct SingleLineTextField: View {
    enum InputType {
        case text
        case phoneNumber
    }

    @Binding private var text: String

    @FocusState private var isFocused: Bool

    private let title: String?
    private let placeholder: String
    private let inputType: InputType
    private let errorMessage: String?

    init(
        title: String? = nil,
        text: Binding<String>,
        placeholder: String = "",
        inputType: InputType = .text,
        errorMessage: String? = nil
    ) {
        _text = text
        self.title = title
        self.placeholder = placeholder
        self.inputType = inputType
        self.errorMessage = errorMessage
    }

    var body: some View {
        InputFieldContainer(
            title: title,
            errorMessage: isFocused ? nil : errorMessage,
            isFocused: isFocused
        ) {
            TextField(placeholder, text: $text)
                .typography(.h3Rg14)
                .keyboardType(keyboardType)
                .focused($isFocused)
                .frame(height: Metric.height)
                .onChange(of: text) { _, newValue in
                    formatIfNeeded(newValue)
                }
        }
    }

    private var keyboardType: UIKeyboardType {
        switch inputType {
        case .text:
            return .default
        case .phoneNumber:
            return .numberPad
        }
    }

    private func formatIfNeeded(_ newValue: String) {
        guard inputType == .phoneNumber else { return }

        let formattedValue = newValue.formattedPhoneNumber
        guard formattedValue != newValue else { return }
        text = formattedValue
    }
}

private enum Metric {
    static let height: CGFloat = 52
}
