//
//  SearchHeader.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

struct SearchHeader<TrailingContent: View>: View {
    @Binding private var searchText: String

    @Environment(\.dismiss) private var dismiss

    private let placeholder: String
    private let onBack: (() -> Void)?
    private let onSubmit: () -> Void
    private let trailingContent: TrailingContent

    init(
        searchText: Binding<String>,
        placeholder: String = "",
        onBack: (() -> Void)? = nil,
        onSubmit: @escaping () -> Void = {},
        @ViewBuilder trailingContent: () -> TrailingContent
    ) {
        _searchText = searchText
        self.placeholder = placeholder
        self.onBack = onBack
        self.onSubmit = onSubmit
        self.trailingContent = trailingContent()
    }

    var body: some View {
        HStack(spacing: Metric.spacing) {
            backButton
            searchField
            trailingContent
        }
        .padding(.horizontal, Metric.horizontalPadding)
        .frame(height: Metric.height)
    }

    private var backButton: some View {
        Button {
            if let onBack {
                onBack()
            } else {
                dismiss()
            }
        } label: {
            Image(systemName: "chevron.left")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.primary)
                .frame(width: Metric.iconSize, height: Metric.iconSize)
        }
    }

    private var searchField: some View {
        HStack(spacing: Metric.fieldSpacing) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.secondary)

            TextField(placeholder, text: $searchText)
                .typography(.h1Rg16)
                .submitLabel(.search)
                .onSubmit(onSubmit)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.secondary)
                }
            }
        }
        .padding(.horizontal, Metric.fieldHorizontalPadding)
        .frame(height: Metric.fieldHeight)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: Metric.fieldCornerRadius))
    }
}

extension SearchHeader where TrailingContent == EmptyView {
    init(
        searchText: Binding<String>,
        placeholder: String = "",
        onBack: (() -> Void)? = nil,
        onSubmit: @escaping () -> Void = {}
    ) {
        self.init(
            searchText: searchText,
            placeholder: placeholder,
            onBack: onBack,
            onSubmit: onSubmit,
            trailingContent: { EmptyView() }
        )
    }
}

private enum Metric {
    static let height: CGFloat = 56
    static let spacing: CGFloat = 8
    static let horizontalPadding: CGFloat = 16
    static let iconSize: CGFloat = 32
    static let fieldHeight: CGFloat = 40
    static let fieldSpacing: CGFloat = 8
    static let fieldHorizontalPadding: CGFloat = 12
    static let fieldCornerRadius: CGFloat = 10
}
