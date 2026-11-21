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
            HomeView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .childRegister:
            ChildRegisterView()
        case .childDetail(let childID):
            ChildDetailView(childID: childID)
        case .recordInput:
            RecordInputView()
        case .voiceInput:
            VoiceInputView(viewModel: VoiceInputViewModel(service: dependency.voiceInputService))
        case .recordList(let childID):
            RecordListView(childID: childID)
        case .recordEdit(let recordID):
            RecordEditView(recordID: recordID)
        case .briefing:
            BriefingView()
        case .sendTarget:
            SendTargetView()
        case .sendConfirm:
            SendConfirmView()
        case .sendResult:
            SendResultView()
        case .sendHistory:
            SendHistoryView()
        }
    }
}
