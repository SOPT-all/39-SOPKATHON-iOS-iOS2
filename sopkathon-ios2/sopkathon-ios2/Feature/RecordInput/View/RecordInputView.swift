//
//  RecordInputView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

import SwiftUI

struct RecordInputView: View {
    @Environment(AppRouter.self) private var router

    @State private var viewModel: RecordInputViewModel

    init(viewModel: RecordInputViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            NavigationHeader(title: Title.navigation, style: .plain)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    childSectionView

                    categorySectionView
                        .padding(.top, Metric.categoryTopPadding)

                    contentSectionView
                        .padding(.top, Metric.contentTopPadding)
                }
                .padding(.horizontal, Metric.horizontalPadding)
                .padding(.top, Metric.topPadding)
                .padding(.bottom, Metric.bottomPadding)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(.baseWhite)
        .safeAreaInset(edge: .bottom) {
            saveButtonView
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.fetchChildren()
        }
    }

    private var childSectionView: some View {
        VStack(alignment: .leading, spacing: Metric.sectionSpacing) {
            sectionTitleView(Title.child)

            DropdownField(
                selection: $viewModel.selectedChild,
                options: viewModel.children,
                placeholder: Title.childPlaceholder
            ) { child in
                child.name
            }
        }
    }

    private var categorySectionView: some View {
        VStack(alignment: .leading, spacing: Metric.categorySpacing) {
            sectionTitleView(Title.category)

            FlowLayout(
                horizontalSpacing: Metric.chipHorizontalSpacing,
                verticalSpacing: Metric.chipVerticalSpacing
            ) {
                ForEach(CareRecordCategoryModel.allCases, id: \.self) { category in
                    Button {
                        viewModel.selectCategory(category)
                    } label: {
                        CategoryChip(
                            category: category,
                            isSelected: category == viewModel.selectedCategory
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var contentSectionView: some View {
        VStack(alignment: .leading, spacing: Metric.sectionSpacing) {
            VStack(alignment: .leading, spacing: Metric.contentTitleSpacing) {
                sectionTitleView(Title.content)

                Text(Title.contentDescription)
                    .font(Typography.caption1.font)
                    .foregroundStyle(.textBlack)
            }

            MultiLineTextField(text: $viewModel.content)
        }
    }

    private var saveButtonView: some View {
        FullWidthButton(title: Title.save, isEnabled: viewModel.canSave) {
            saveRecord()
        }
        .padding(.horizontal, Metric.horizontalPadding)
        .padding(.bottom, Metric.saveButtonBottomPadding)
        .background(.baseWhite)
    }

    private func sectionTitleView(_ title: String) -> some View {
        Text(title)
            .font(Typography.subHeader1.font)
            .foregroundStyle(.textBlack)
    }

    private func saveRecord() {
        Task {
            guard await viewModel.saveRecord() else { return }
            router.pop()
        }
    }
}

private extension RecordInputView {
    enum Metric {
        static let horizontalPadding: CGFloat = 24
        static let topPadding: CGFloat = 34
        static let bottomPadding: CGFloat = 24
        static let sectionSpacing: CGFloat = 14
        static let categoryTopPadding: CGFloat = 33
        static let categorySpacing: CGFloat = 19
        static let chipHorizontalSpacing: CGFloat = 9
        static let chipVerticalSpacing: CGFloat = 8
        static let contentTopPadding: CGFloat = 59
        static let contentTitleSpacing: CGFloat = 6
        static let saveButtonBottomPadding: CGFloat = 15
    }

    enum Title {
        static let navigation = "기록 입력"
        static let child = "아이 선택"
        static let childPlaceholder = "아이를 선택해주세요."
        static let category = "돌봄 카테고리"
        static let content = "돌봄 내용"
        static let contentDescription = "기록하고 싶은 내용을 입력하세요"
        static let save = "저장"
    }
}
