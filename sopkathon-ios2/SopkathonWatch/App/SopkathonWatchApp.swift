//
//  SopkathonWatchApp.swift
//  SopkathonWatch
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

@main
struct SopkathonWatchApp: App {
    @State private var dependency = AppDependency(mode: .live, baseService: BaseService.shared)

    private let phoneSyncService = PhoneSyncService()

    init() {
        phoneSyncService.activate()
    }

    var body: some Scene {
        WindowGroup {
            VoiceMemoView(
                viewModel: VoiceMemoViewModel(
                    service: dependency.careRecordService,
                    phoneSyncService: phoneSyncService
                )
            )
        }
    }
}
