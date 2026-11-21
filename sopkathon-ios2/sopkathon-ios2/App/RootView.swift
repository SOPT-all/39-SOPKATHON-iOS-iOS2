//
//  RootView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

import SwiftUI

struct RootView: View {
    @Environment(AppRouter.self) private var router
    @Environment(AppDependency.self) private var dependency
    @State private var sheetDragOffset: CGFloat = 0
    @State private var voiceInputViewModel: VoiceInputViewModel?

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            tabContentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaInset(edge: .bottom) {
                    if router.selectedTab != .briefing {
                        tabBarView
                    }
                }
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
        .overlay {
            sheetOverlayView
        }
        .animation(
            .easeOut(duration: Metric.sheetAnimationDuration),
            value: router.presentedSheet
        )
        .task {
            if AppPreviewConfiguration.isBriefingEnabled {
                router.selectTab(.briefing)
            }
            await prepareVoiceInput()
        }
    }

    private var sheetOverlayView: some View {
        ZStack(alignment: .bottom) {
            if let sheet = router.presentedSheet {
                Color.baseBlack
                    .opacity(Metric.sheetDimOpacity)
                    .ignoresSafeArea()
                    .transition(.opacity)

                sheetView(for: sheet)
                    .frame(maxWidth: .infinity)
                    .background {
                        UnevenRoundedRectangle(
                            topLeadingRadius: Metric.sheetCornerRadius,
                            topTrailingRadius: Metric.sheetCornerRadius
                        )
                        .fill(.baseWhite)
                        .ignoresSafeArea(edges: .bottom)
                    }
                    .offset(y: sheetDragOffset)
                    .gesture(sheetDragGesture)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
            }
        }
        .onChange(of: router.presentedSheet) { _, sheet in
            guard sheet != nil else { return }
            sheetDragOffset = 0
        }
    }

    private var sheetDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                sheetDragOffset = max(value.translation.height, 0)
            }
            .onEnded { value in
                guard value.translation.height > Metric.sheetDismissDistance else {
                    withAnimation(.easeOut(duration: Metric.sheetAnimationDuration)) {
                        sheetDragOffset = 0
                    }
                    return
                }
                router.dismissSheet()
            }
    }

    @ViewBuilder
    private var tabContentView: some View {
        switch router.selectedTab {
        case .home:
            HomeView(viewModel: HomeViewModel(service: dependency.homeService))
        case .briefing:
            BriefingView(viewModel: BriefingViewModel(service: dependency.briefingService))
        case .childList:
            ChildListView(viewModel: ChildListViewModel(service: dependency.childService))
        }
    }

    private var tabBarView: some View {
        HStack(spacing: Metric.tabItemSpacing) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                tabItemView(tab)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Metric.tabBarInnerPadding)
        .frame(height: Metric.tabBarHeight)
        .background(.baseWhite)
        .clipShape(Capsule())
        .shadow(
            color: .baseBlack.opacity(Metric.tabBarShadowOpacity),
            radius: Metric.tabBarShadowRadius
        )
        .padding(.horizontal, Metric.tabBarOuterPadding)
    }

    private func tabItemView(_ tab: AppTab) -> some View {
        Button {
            router.selectTab(tab)
        } label: {
            let isSelected = tab == router.selectedTab

            VStack(spacing: Metric.tabIconTitleSpacing) {
                Image(tab.icon(isSelected: isSelected))
                    .resizable()
                    .frame(width: tab.iconSize, height: tab.iconSize)

                Text(tab.title)
                    .typography(.caption3)
                    .foregroundStyle(isSelected ? .primary500 : .disabled150)
                    .lineLimit(1)
                    .fixedSize()
            }
            .frame(minWidth: Metric.tabItemSize, minHeight: Metric.tabItemSize)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .childRegister:
            ChildRegisterView(viewModel: ChildRegisterViewModel(service: dependency.childService))
        case .childDetail(let childID):
            ChildDetailView(
                viewModel: ChildDetailViewModel(
                    childID: childID,
                    service: dependency.childService
                )
            )
        case .recordInput:
            RecordInputView(
                viewModel: RecordInputViewModel(
                    childService: dependency.childService,
                    careRecordService: dependency.careRecordService
                )
            )
        }
    }

    @ViewBuilder
    private func sheetView(for sheet: AppSheet) -> some View {
        switch sheet {
        case .voiceInput(let teacherName):
            if let voiceInputViewModel {
                VoiceInputView(teacherName: teacherName, viewModel: voiceInputViewModel)
            }
        }
    }

    private func prepareVoiceInput() async {
        let viewModel = VoiceInputViewModel(
            service: dependency.voiceInputService,
            careRecordService: dependency.careRecordService,
            childService: dependency.childService
        )
        voiceInputViewModel = viewModel
        await viewModel.fetchChildren()
    }
}

private extension RootView {
    enum Metric {
        static let tabBarHeight: CGFloat = 84
        static let tabBarInnerPadding: CGFloat = 35
        static let tabBarOuterPadding: CGFloat = 24
        static let tabItemSpacing: CGFloat = 50
        static let tabItemSize: CGFloat = 48
        static let tabIconTitleSpacing: CGFloat = 3
        static let tabBarShadowOpacity: Double = 0.1
        static let tabBarShadowRadius: CGFloat = 4
        static let sheetCornerRadius: CGFloat = 30
        static let sheetDimOpacity: Double = 0.56
        static let sheetDismissDistance: CGFloat = 100
        static let sheetAnimationDuration: Double = 0.25
    }
}
