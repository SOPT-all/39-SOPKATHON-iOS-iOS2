//
//  NavigationHeader.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

struct NavigationHeader: View {
    @Environment(\.dismiss) private var dismiss

    private let title: String

    init(title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(Typography.subHeader1.font)
            .foregroundStyle(.textBlack)
            .frame(maxWidth: .infinity)
            .frame(height: Metric.height)
            .overlay(alignment: .leading) {
                Button {
                    dismiss()
                } label: {
                    Image(.iconBack)
                        .frame(width: Metric.height, height: Metric.height)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, Metric.horizontalPadding)
            .padding(.top, Metric.topPadding)
    }
}

private extension NavigationHeader {
    enum Metric {
        static let height: CGFloat = 24
        static let horizontalPadding: CGFloat = 24
        static let topPadding: CGFloat = 17
    }
}
