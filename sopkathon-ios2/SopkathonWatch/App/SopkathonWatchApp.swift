//
//  SopkathonWatchApp.swift
//  SopkathonWatch
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

@main
struct SopkathonWatchApp: App {
    @State private var viewModel: VoiceMemoViewModel

    init() {
        let dependency = AppDependency(mode: .live, baseService: BaseService.shared)
        _viewModel = State(
            initialValue: VoiceMemoViewModel(
                recorderService: dependency.voiceRecorderService,
                phoneSyncService: dependency.phoneSyncService
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            VoiceMemoView(viewModel: viewModel)
        }
    }
}
