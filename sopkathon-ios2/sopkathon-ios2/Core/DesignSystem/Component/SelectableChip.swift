//
//  SelectableChip.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

struct SelectableChip: View {
    private let title: String
    private let image: Image?
    private let isSelected: Bool
    private let action: () -> Void

    init(
        title: String,
        image: Image? = nil,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.image = image
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: Metric.spacing) {
                if let image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: Metric.imageSize, height: Metric.imageSize)
                }

                Text(title)
                    .typography(.body4)
            }
            .foregroundStyle(isSelected ? Color(.systemBackground) : Color.primary)
            .padding(.horizontal, Metric.horizontalPadding)
            .frame(height: Metric.height)
            .background(isSelected ? Color.primary : Color(.systemGray6))
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(
                        isSelected ? Color.clear : Color(.systemGray5),
                        lineWidth: Metric.borderWidth
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

private enum Metric {
    static let height: CGFloat = 36
    static let spacing: CGFloat = 4
    static let horizontalPadding: CGFloat = 14
    static let imageSize: CGFloat = 16
    static let borderWidth: CGFloat = 1
}
