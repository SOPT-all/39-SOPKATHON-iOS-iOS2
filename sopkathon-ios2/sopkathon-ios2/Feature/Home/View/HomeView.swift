//
//  HomeView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) private var router
    @Environment(WatchSyncReceiver.self) private var watchSyncReceiver
    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                headerView

                childrenView
                    .padding(.top, Metric.childrenTopPadding)

                memoSectionView
                    .padding(.top, Metric.memoSectionTopPadding)

                recordSectionView
                    .padding(.top, Metric.recordSectionTopPadding)

                shortcutSectionView
                    .padding(.top, Metric.shortcutSectionTopPadding)
            }
            .padding(.horizontal, Metric.horizontalPadding)
            .padding(.vertical, Metric.verticalPadding)
        }
        .background { backgroundView }
        .task(id: watchSyncReceiver.careRecordSavedCount) {
            await viewModel.fetchHome()
        }
    }

    private var children: [HomeChildModel] {
        viewModel.home?.children ?? []
    }

    private var records: [HomeRecordModel] {
        viewModel.home?.records ?? []
    }

    private var backgroundView: some View {
        VStack(spacing: 0) {
            Color.baseWhite
                .frame(height: Metric.gradientTopOffset)

            LinearGradient(
                colors: [.baseWhite, .baseGradient],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(.iconManageOn)
                .resizable()
                .frame(width: Metric.logoSize, height: Metric.logoSize)
                .offset(x: Metric.logoOffsetX)
                .padding(.top, Metric.logoTopPadding)

            Text(viewModel.todayText)
                .typography(.caption1)
                .foregroundStyle(.textBlack)
                .padding(.top, Metric.dateTopPadding)

            Text("\(viewModel.home?.teacherName ?? "") 선생님 반갑습니다")
                .typography(.header1)
                .foregroundStyle(.textBlack)
                .padding(.top, Metric.greetingTopPadding)
        }
    }

    private var childrenView: some View {
        VStack(alignment: .leading, spacing: Metric.childrenSpacing) {
            HStack {
                Text("아직은 아이들에 대한 돌봄 기록이 없어요!")
                    .typography(.caption1)
                    .foregroundStyle(.textBlack)

                Spacer()

                Button {
                    Task { await viewModel.fetchHome() }
                } label: {
                    Image(.iconRefresh)
                        .resizable()
                        .frame(width: Metric.refreshIconSize, height: Metric.refreshIconSize)
                }
                .buttonStyle(.plain)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Metric.cardSpacing) {
                    ForEach(children) { child in
                        ProfileCard(childID: child.id, name: child.name, size: .large)
                    }
                }
            }
        }
    }

    private var memoSectionView: some View {
        VStack(alignment: .leading, spacing: Metric.sectionTitleSpacing) {
            sectionTitle("돌봄 기록 작성하기")

            HStack(spacing: Metric.cardSpacing) {
                HomeMemoCard(kind: .text) {
                    router.push(.recordInput)
                }

                HomeMemoCard(kind: .voice) {
                    router.presentSheet(.voiceInput)
                }
            }
        }
    }

    private var recordSectionView: some View {
        VStack(alignment: .leading, spacing: Metric.sectionTitleSpacing) {
            sectionTitle("오늘의 기록")

            ScrollView(showsIndicators: false) {
                VStack(spacing: Metric.recordSpacing) {
                    ForEach(records) { record in
                        HomeRecordRow(
                            childID: record.childID,
                            name: record.childName,
                            time: viewModel.timeText(for: record.recordedAt),
                            category: record.category
                        )
                    }
                }
                .padding(.horizontal, Metric.recordHorizontalPadding)
                .padding(.vertical, Metric.recordVerticalPadding)
            }
            .frame(height: Metric.recordBoxHeight)
            .background(.baseWhite)
            .clipShape(RoundedRectangle(cornerRadius: Metric.cardCornerRadius))
            .shadow(
                color: .baseBlack.opacity(Metric.recordShadowOpacity),
                radius: Metric.recordShadowRadius
            )
        }
    }

    private var shortcutSectionView: some View {
        VStack(alignment: .leading, spacing: Metric.shortcutTitleSpacing) {
            sectionTitle("바로가기")

            HStack {
                Text("오늘 하루 브리핑 작성하기")
                    .typography(.body1)
                    .foregroundStyle(.textBlack)

                Spacer()

                Button {
                    router.selectTab(.briefing)
                } label: {
                    Text("바로가기")
                        .typography(.body2)
                        .foregroundStyle(.primary600)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, Metric.shortcutHorizontalPadding)
            .frame(height: Metric.shortcutHeight)
            .background(.baseWhite)
            .clipShape(RoundedRectangle(cornerRadius: Metric.cardCornerRadius))
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .typography(.subHeader1)
            .foregroundStyle(.textBlack)
    }
}

private extension HomeView {
    enum Metric {
        static let horizontalPadding: CGFloat = 24
        static let verticalPadding: CGFloat = 18
        static let gradientTopOffset: CGFloat = 281
        static let logoSize: CGFloat = 30
        static let logoOffsetX: CGFloat = -4
        static let logoTopPadding: CGFloat = 2
        static let dateTopPadding: CGFloat = 3
        static let greetingTopPadding: CGFloat = 5
        static let childrenTopPadding: CGFloat = 22
        static let childrenSpacing: CGFloat = 8
        static let refreshIconSize: CGFloat = 24
        static let cardSpacing: CGFloat = 13
        static let memoSectionTopPadding: CGFloat = 37
        static let recordSectionTopPadding: CGFloat = 29
        static let shortcutSectionTopPadding: CGFloat = 25
        static let sectionTitleSpacing: CGFloat = 12
        static let shortcutTitleSpacing: CGFloat = 14
        static let cardCornerRadius: CGFloat = 15
        static let recordBoxHeight: CGFloat = 188
        static let recordSpacing: CGFloat = 18
        static let recordHorizontalPadding: CGFloat = 16
        static let recordVerticalPadding: CGFloat = 13
        static let recordShadowOpacity: Double = 0.05
        static let recordShadowRadius: CGFloat = 7.5
        static let shortcutHorizontalPadding: CGFloat = 15
        static let shortcutHeight: CGFloat = 70
    }
}
