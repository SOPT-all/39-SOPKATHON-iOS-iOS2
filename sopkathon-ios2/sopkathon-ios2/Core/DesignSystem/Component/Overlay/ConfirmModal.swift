//
//  ConfirmModal.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

struct ConfirmModal: View {
    private let title: String
    private let message: String
    private let cancelTitle: String
    private let confirmTitle: String
    private let confirmAppearance: ButtonAppearance
    private let onCancel: () -> Void
    private let onConfirm: () -> Void

    init(
        title: String,
        message: String,
        cancelTitle: String,
        confirmTitle: String,
        confirmAppearance: ButtonAppearance,
        onCancel: @escaping () -> Void,
        onConfirm: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.cancelTitle = cancelTitle
        self.confirmTitle = confirmTitle
        self.confirmAppearance = confirmAppearance
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Metric.spacing) {
            Text(title)
                .typography(.subHeader2)
                .foregroundStyle(Color.primary)

            Text(message)
                .typography(.body5)
                .foregroundStyle(Color.secondary)
                .fixedSize(horizontal: false, vertical: true)

            buttonRow
        }
        .padding(Metric.padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Metric.cornerRadius))
        .padding(.horizontal, Metric.horizontalMargin)
    }

    private var buttonRow: some View {
        HStack(spacing: Metric.buttonSpacing) {
            Spacer()

            CompactButton(title: cancelTitle, appearance: .secondary, action: onCancel)
            CompactButton(title: confirmTitle, appearance: confirmAppearance, action: onConfirm)
        }
    }
}

struct ConfirmModalModifier: ViewModifier {
    @Binding private var isPresented: Bool

    private let title: String
    private let message: String
    private let cancelTitle: String
    private let confirmTitle: String
    private let confirmAppearance: ButtonAppearance
    private let onConfirm: () -> Void

    init(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        cancelTitle: String,
        confirmTitle: String,
        confirmAppearance: ButtonAppearance,
        onConfirm: @escaping () -> Void
    ) {
        _isPresented = isPresented
        self.title = title
        self.message = message
        self.cancelTitle = cancelTitle
        self.confirmTitle = confirmTitle
        self.confirmAppearance = confirmAppearance
        self.onConfirm = onConfirm
    }

    func body(content: Content) -> some View {
        content
            .transaction(value: isPresented) { transaction in
                transaction.disablesAnimations = true
            }
            .fullScreenCover(isPresented: $isPresented) {
                ZStack {
                    Color.black
                        .opacity(Metric.dimOpacity)
                        .ignoresSafeArea()

                    ConfirmModal(
                        title: title,
                        message: message,
                        cancelTitle: cancelTitle,
                        confirmTitle: confirmTitle,
                        confirmAppearance: confirmAppearance,
                        onCancel: { isPresented = false },
                        onConfirm: {
                            isPresented = false
                            onConfirm()
                        }
                    )
                }
                .presentationBackground(.clear)
            }
    }
}

private enum Metric {
    static let spacing: CGFloat = 12
    static let padding: CGFloat = 24
    static let horizontalMargin: CGFloat = 24
    static let cornerRadius: CGFloat = 12
    static let buttonSpacing: CGFloat = 8
    static let dimOpacity: Double = 0.4
}
