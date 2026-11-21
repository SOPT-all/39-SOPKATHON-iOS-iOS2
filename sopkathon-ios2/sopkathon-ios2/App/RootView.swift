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
    }

    @ViewBuilder
    private var tabContentView: some View {
        switch router.selectedTab {
        case .home:
            HomeView()
        case .briefing:
            BriefingView(viewModel: BriefingViewModel(service: dependency.briefingService))
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
        case .recordInput(let content):
            RecordInputView(viewModel: RecordInputViewModel(content: content))
        case .voiceInput:
            VoiceInputView(viewModel: VoiceInputViewModel(service: dependency.voiceInputService))
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
    }
}
