//
//  View+.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        title: String,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            BottomSheetModifier(
                isPresented: isPresented,
                title: title,
                sheetContent: content
            )
        )
    }

    func confirmModal(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        cancelTitle: String,
        confirmTitle: String,
        confirmAppearance: ButtonAppearance = .primary,
        onConfirm: @escaping () -> Void
    ) -> some View {
        modifier(
            ConfirmModalModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                cancelTitle: cancelTitle,
                confirmTitle: confirmTitle,
                confirmAppearance: confirmAppearance,
                onConfirm: onConfirm
            )
        )
    }
}
