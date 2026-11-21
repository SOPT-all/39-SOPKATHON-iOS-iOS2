//
//  DropdownField.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

struct DropdownField<Option: Hashable>: View {
    @Binding private var selection: Option?

    private let title: String?
    private let options: [Option]
    private let placeholder: String
    private let optionTitle: (Option) -> String

    init(
        title: String? = nil,
        selection: Binding<Option?>,
        options: [Option],
        placeholder: String = "선택해 주세요",
        optionTitle: @escaping (Option) -> String
    ) {
        _selection = selection
        self.title = title
        self.options = options
        self.placeholder = placeholder
        self.optionTitle = optionTitle
    }

    var body: some View {
        InputFieldContainer(title: title) {
            Menu {
                ForEach(options, id: \.self) { option in
                    optionButton(option)
                }
            } label: {
                menuLabel
            }
        }
    }

    private var menuLabel: some View {
        HStack {
            Text(selection.map(optionTitle) ?? placeholder)
                .typography(.h3Rg14)
                .foregroundStyle(selection == nil ? Color(.placeholderText) : Color.primary)

            Spacer()

            Image(systemName: "chevron.down")
                .foregroundStyle(Color.secondary)
        }
        .frame(height: Metric.height)
        .contentShape(Rectangle())
    }

    private func optionButton(_ option: Option) -> some View {
        Button {
            selection = option
        } label: {
            if option == selection {
                Label(optionTitle(option), systemImage: "checkmark")
            } else {
                Text(optionTitle(option))
            }
        }
    }
}

private enum Metric {
    static let height: CGFloat = 52
}
