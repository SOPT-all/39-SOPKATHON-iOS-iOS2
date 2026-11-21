//
//  BottomSheet.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import SwiftUI

struct BottomSheet<Content: View>: View {
    @Environment(\.dismiss) private var dismiss

    private let title: String
    private let content: Content

    init(
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(spacing: Metric.spacing) {
            titleBar
            content
        }
        .padding(.top, Metric.topPadding)
        .padding(.horizontal, Metric.horizontalPadding)
        .padding(.bottom, Metric.bottomPadding)
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
    }

    private var titleBar: some View {
        HStack {
            Text(title)
                .typography(.displayB18)

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.secondary)
            }
        }
    }
}

struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding private var isPresented: Bool

    @State private var sheetHeight: CGFloat = .zero

    private let title: String
    private let sheetContent: () -> SheetContent

    init(
        isPresented: Binding<Bool>,
        title: String,
        sheetContent: @escaping () -> SheetContent
    ) {
        _isPresented = isPresented
        self.title = title
        self.sheetContent = sheetContent
    }

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                BottomSheet(title: title, content: sheetContent)
                    .onGeometryChange(for: CGFloat.self) { proxy in
                        proxy.size.height
                    } action: { height in
                        sheetHeight = height
                    }
                    .presentationDetents(
                        sheetHeight > .zero ? [.height(sheetHeight)] : [.medium]
                    )
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Color.white)
                    .presentationCornerRadius(Metric.cornerRadius)
            }
    }
}

private enum Metric {
    static let spacing: CGFloat = 20
    static let topPadding: CGFloat = 28
    static let horizontalPadding: CGFloat = 20
    static let bottomPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 20
}
