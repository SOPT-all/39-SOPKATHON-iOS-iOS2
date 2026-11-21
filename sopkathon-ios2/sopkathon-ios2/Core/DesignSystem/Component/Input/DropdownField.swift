//
//  DropdownField.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

struct DropdownField<Option: Hashable>: View {
    @Binding private var selection: Option?
    @State private var isExpanded = false

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
        InputFieldContainer(title: title, isFocused: isExpanded) {
            VStack(spacing: 0) {
                headerButton

                if isExpanded {
                    Divider()

                    optionList
                }
            }
        }
    }

    private var headerButton: some View {
        Button {
            withAnimation(.easeInOut(duration: Metric.animationDuration)) {
                isExpanded.toggle()
            }
        } label: {
            HStack {
                Text(selection.map(optionTitle) ?? placeholder)
                    .typography(.body5)
                    .foregroundStyle(selection == nil ? Color(.placeholderText) : Color.primary)

                Spacer()

                Image(systemName: "chevron.down")
                    .foregroundStyle(Color.secondary)
                    .rotationEffect(.degrees(isExpanded ? Metric.expandedChevronDegrees : 0))
            }
            .frame(height: Metric.headerHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var optionList: some View {
        VStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                optionRow(option)
            }
        }
    }

    private func optionRow(_ option: Option) -> some View {
        Button {
            withAnimation(.easeInOut(duration: Metric.animationDuration)) {
                selection = option
                isExpanded = false
            }
        } label: {
            HStack {
                Text(optionTitle(option))
                    .typography(option == selection ? .body4 : .body5)
                    .foregroundStyle(Color.primary)

                Spacer()

                if option == selection {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.primary)
                }
            }
            .frame(height: Metric.optionHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private enum Metric {
    static let headerHeight: CGFloat = 52
    static let optionHeight: CGFloat = 44
    static let animationDuration: Double = 0.2
    static let expandedChevronDegrees: Double = 180
}
