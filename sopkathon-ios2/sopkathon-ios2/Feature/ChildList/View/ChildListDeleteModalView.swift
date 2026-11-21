//
//  ChildListDeleteModalView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

struct ChildListDeleteModalView: View {
    @Environment(AppRouter.self) private var router

    @State private var viewModel: ChildListDeleteViewModel

    private let child: ChildModel

    init(child: ChildModel, viewModel: ChildListDeleteViewModel) {
        self.child = child
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: Metric.spacing) {
            ProfileCard(childID: child.id, name: child.name, size: .extraLarge)

            VStack(spacing: Metric.buttonTopSpacing) {
                VStack(alignment: .leading, spacing: Metric.textSpacing) {
                    Text(Title.title)
                        .typography(.subHeader1)
                        .foregroundStyle(.textBlack)

                    Text(Title.message)
                        .typography(.caption1)
                        .foregroundStyle(.disabled200)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: Metric.buttonSpacing) {
                    buttonView(Title.cancel, foreground: .textBlack, background: .gray100) {
                        router.dismissSheet()
                    }

                    buttonView(Title.delete, foreground: .baseWhite, background: .primary400) {
                        deleteChild()
                    }
                }
            }
        }
        .padding(.horizontal, Metric.horizontalPadding)
        .padding(.top, Metric.topPadding)
        .padding(.bottom, Metric.bottomPadding)
        .background(.baseWhite)
        .clipShape(RoundedRectangle(cornerRadius: Metric.cornerRadius))
        .frame(maxWidth: Metric.maxWidth)
        .padding(.horizontal, Metric.margin)
    }

    private func buttonView(
        _ title: String,
        foreground: Color,
        background: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .typography(.body1)
                .foregroundStyle(foreground)
                .frame(maxWidth: .infinity)
                .frame(height: Metric.buttonHeight)
                .background(background)
                .clipShape(RoundedRectangle(cornerRadius: Metric.buttonCornerRadius))
        }
        .buttonStyle(.plain)
    }

    private func deleteChild() {
        Task {
            await viewModel.deleteChild()
            router.dismissSheet()
        }
    }
}

private extension ChildListDeleteModalView {
    enum Metric {
        static let spacing: CGFloat = 26
        static let textSpacing: CGFloat = 9
        static let buttonTopSpacing: CGFloat = 20
        static let buttonSpacing: CGFloat = 15
        static let buttonHeight: CGFloat = 45
        static let buttonCornerRadius: CGFloat = 10
        static let horizontalPadding: CGFloat = 20
        static let topPadding: CGFloat = 31
        static let bottomPadding: CGFloat = 15
        static let cornerRadius: CGFloat = 30
        static let maxWidth: CGFloat = 331
        static let margin: CGFloat = 31
    }

    enum Title {
        static let title = "아이 정보 삭제"
        static let message = "삭제시 아이의 모든 돌봄 기록과 연락처 정보가\n"
            + "함께 삭제되며 되돌릴 수 없습니다."
        static let cancel = "취소"
        static let delete = "삭제"
    }
}
