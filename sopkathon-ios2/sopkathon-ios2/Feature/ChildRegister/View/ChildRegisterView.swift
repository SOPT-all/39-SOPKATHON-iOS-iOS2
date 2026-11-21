//
//  ChildRegisterView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

import SwiftUI

struct ChildRegisterView: View {
    @Environment(AppRouter.self) private var router

    @State private var viewModel: ChildRegisterViewModel

    init(viewModel: ChildRegisterViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            ChildFormView(
                childName: $viewModel.childName,
                gender: $viewModel.gender,
                parentName: $viewModel.parentName,
                parentPhoneNumber: $viewModel.parentPhoneNumber,
                relationship: $viewModel.relationship,
                notes: $viewModel.notes,
                isValidParentPhoneNumber: viewModel.isValidParentPhoneNumber
            )
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.baseWhite)
        .safeAreaInset(edge: .bottom) {
            submitButtonView
        }
        .navigationTitle(Title.navigation)
        .navigationBarTitleDisplayMode(.inline)
        .backButton {
            router.pop()
        }
    }

    private var submitButtonView: some View {
        FullWidthButton(title: Title.submit, isEnabled: viewModel.canSubmit) {
            router.pop()
        }
        .padding(.horizontal, Metric.horizontalPadding)
        .padding(.vertical, Metric.buttonVerticalPadding)
        .background(Color.baseWhite)
    }
}

private extension ChildRegisterView {
    enum Metric {
        static let horizontalPadding: CGFloat = 24
        static let buttonVerticalPadding: CGFloat = 9
    }

    enum Title {
        static let navigation = "아이 등록"
        static let submit = "등록 완료"
    }
}
