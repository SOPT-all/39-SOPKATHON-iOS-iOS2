//
//  SearchBar.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

struct SearchBar: View {
    @Binding private var text: String

    private let placeholder: String
    private let onSubmit: () -> Void

    init(
        text: Binding<String>,
        placeholder: String = "",
        onSubmit: @escaping () -> Void = {}
    ) {
        _text = text
        self.placeholder = placeholder
        self.onSubmit = onSubmit
    }

    var body: some View {
        HStack(spacing: Metric.spacing) {
            TextField(
                "",
                text: $text,
                prompt: Text(placeholder).foregroundStyle(.disabled200)
            )
            .font(Typography.caption2.font)
            .foregroundStyle(.textBlack)
            .submitLabel(.search)
            .onSubmit(onSubmit)

            Image(.iconSearch)
                .resizable()
                .scaledToFit()
                .frame(width: Metric.iconSize, height: Metric.iconSize)
        }
        .padding(.horizontal, Metric.horizontalPadding)
        .frame(height: Metric.height)
        .background(.baseWhite)
        .clipShape(RoundedRectangle(cornerRadius: Metric.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Metric.cornerRadius)
                .stroke(.gray300, lineWidth: Metric.borderWidth)
        }
    }
}

private extension SearchBar {
    enum Metric {
        static let height: CGFloat = 48
        static let horizontalPadding: CGFloat = 12
        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 1
        static let spacing: CGFloat = 8
        static let iconSize: CGFloat = 20
    }
}
