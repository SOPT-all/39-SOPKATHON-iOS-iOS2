//
//  ChildListView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

struct ChildListView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel: ChildListViewModel

    init(viewModel: ChildListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: Metric.searchBarBottomSpacing) {
            SearchBar(text: $viewModel.keyword, placeholder: Title.searchPlaceholder)
                .padding(.horizontal, Metric.horizontalPadding)
                .padding(.top, Metric.topPadding)

            childListView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay(alignment: .bottomTrailing) {
            registerButton
        }
        .background { backgroundView }
        .task(id: viewModel.keyword) {
            await viewModel.fetchChildren()
        }
        .onChange(of: router.presentedSheet) { oldSheet, newSheet in
            guard case .childDelete = oldSheet, newSheet == nil else { return }
            Task { await viewModel.fetchChildren() }
        }
    }

    private var childListView: some View {
        List {
            if viewModel.hasFetched {
                ForEach(viewModel.children) { child in
                    childRowView(child)
                        .listRowInsets(Metric.rowInsets)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(Title.delete) {
                                router.presentSheet(.childDelete(child: child))
                            }
                            .tint(.primary400)
                        }
                }
            } else {
                ForEach(0..<Metric.skeletonRowCount, id: \.self) { _ in
                    childSkeletonRowView
                        .listRowInsets(Metric.rowInsets)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.immediately)
        .contentMargins(.bottom, Metric.listBottomMargin, for: .scrollContent)
    }

    private var childSkeletonRowView: some View {
        HStack(spacing: Metric.rowSpacing) {
            SkeletonBox(
                width: ProfileCardSize.small.length,
                height: ProfileCardSize.small.length,
                cornerRadius: ProfileCardSize.small.cornerRadius
            )

            SkeletonBox(width: Metric.skeletonNameWidth, height: Metric.skeletonNameHeight)

            Spacer()
        }
        .frame(height: Metric.rowHeight)
    }

    private var registerButton: some View {
        Button {
            router.push(.childRegister)
        } label: {
            Text(Title.register)
                .typography(.body1)
                .foregroundStyle(.baseWhite)
                .padding(.horizontal, Metric.registerHorizontalPadding)
                .frame(height: Metric.registerHeight)
                .background(.primary400)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .padding(.trailing, Metric.horizontalPadding)
        .padding(.bottom, Metric.registerBottomPadding)
    }

    private var backgroundView: some View {
        VStack(spacing: 0) {
            Color.baseWhite
                .frame(height: Metric.gradientTopOffset)

            LinearGradient(
                colors: [.baseWhite, .baseGradient.opacity(Metric.gradientOpacity)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
    }

    private func childRowView(_ child: ChildModel) -> some View {
        HStack(spacing: Metric.rowSpacing) {
            ProfileCard(childID: child.id, name: child.name)

            Text(child.name)
                .typography(.caption3)
                .foregroundStyle(.textBlack)
                .lineLimit(1)

            Spacer()

            Button {
                router.push(.childDetail(childID: child.id))
            } label: {
                Text(Title.edit)
                    .typography(.caption2)
                    .foregroundStyle(.disabled200)
                    .frame(width: Metric.editWidth, height: Metric.editHeight)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .frame(height: Metric.rowHeight)
    }
}

private extension ChildListView {
    enum Metric {
        static let horizontalPadding: CGFloat = 24
        static let topPadding: CGFloat = 12
        static let searchBarBottomSpacing: CGFloat = 13
        static let rowInsets = EdgeInsets(top: 7.5, leading: 24, bottom: 7.5, trailing: 24)
        static let rowHeight: CGFloat = 50
        static let rowSpacing: CGFloat = 12
        static let editWidth: CGFloat = 52
        static let editHeight: CGFloat = 36
        static let listBottomMargin: CGFloat = 80
        static let registerHeight: CGFloat = 48
        static let registerHorizontalPadding: CGFloat = 19
        static let registerBottomPadding: CGFloat = 17
        static let gradientTopOffset: CGFloat = 130
        static let gradientOpacity: Double = 0.8
        static let skeletonRowCount = 6
        static let skeletonNameWidth: CGFloat = 72
        static let skeletonNameHeight: CGFloat = 16
    }

    enum Title {
        static let searchPlaceholder = "아이 이름으로 검색"
        static let register = "아이 등록"
        static let edit = "수정"
        static let delete = "삭제"
    }
}
