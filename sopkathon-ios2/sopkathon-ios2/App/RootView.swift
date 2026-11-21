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

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            tabContentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaInset(edge: .bottom) {
                    tabBarView
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
            BriefingView()
        case .childList:
            ChildListView()
        }
    }

    private var tabBarView: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                tabItemView(tab)
            }
        }
        .padding(.horizontal, Metric.tabBarInnerPadding)
        .frame(height: Metric.tabBarHeight)
        .background(Color.gray100)
        .clipShape(Capsule())
        .padding(.horizontal, Metric.tabBarOuterPadding)
    }

    private func tabItemView(_ tab: AppTab) -> some View {
        Button {
            router.selectTab(tab)
        } label: {
            VStack(spacing: Metric.tabItemSpacing) {
                Image(systemName: tab.symbolName)
                    .font(.system(size: Metric.tabIconSize))

                Text(tab.title)
                    .typography(.caption3)
            }
            .foregroundStyle(tab == router.selectedTab ? Color.baseBlack : Color.disabled200)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .childRegister:
            ChildRegisterView()
        case .childDetail(let childID):
            ChildDetailView(childID: childID)
        case .recordInput:
            RecordInputView(viewModel: RecordInputViewModel())
        }
    }

    @ViewBuilder
    private func sheetView(for sheet: AppSheet) -> some View {
        switch sheet {
        case .voiceInput:
            VoiceInputView(
                viewModel: VoiceInputViewModel(
                    service: dependency.voiceInputService,
                    careRecordService: dependency.careRecordService
                )
            )
        }
    }
}

private extension RootView {
    enum Metric {
        static let tabBarHeight: CGFloat = 84
        static let tabBarInnerPadding: CGFloat = 40
        static let tabBarOuterPadding: CGFloat = 16
        static let tabItemSpacing: CGFloat = 4
        static let tabIconSize: CGFloat = 22
        static let sheetCornerRadius: CGFloat = 30
        static let sheetDimOpacity: Double = 0.56
        static let sheetDismissDistance: CGFloat = 100
        static let sheetAnimationDuration: Double = 0.25
    }
}
