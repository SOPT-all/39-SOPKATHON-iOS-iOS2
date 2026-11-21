//
//  sopkathon_ios2App.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/19/26.
//

import SwiftUI

@main
struct sopkathon_ios2App: App {
    @State private var dependency: AppDependency
    @State private var router = AppRouter()
    @State private var watchSyncReceiver: WatchSyncReceiver
    @State private var notificationService: LocalNotificationService

    init() {
        let dependency = AppDependency(mode: .live, baseService: BaseService.shared)
        let notificationService = LocalNotificationService()
        _dependency = State(initialValue: dependency)
        _notificationService = State(initialValue: notificationService)
        _watchSyncReceiver = State(
            initialValue: WatchSyncReceiver(
                voiceInputService: dependency.voiceInputService,
                careRecordService: dependency.careRecordService,
                childService: dependency.childService,
                notificationService: notificationService
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(dependency)
                .environment(router)
                .environment(watchSyncReceiver)
                .task {
                    watchSyncReceiver.activate()
                    await notificationService.activate()
                }
                .onChange(of: notificationService.openedCount) {
                    router.dismissSheet()
                    router.popToRoot()
                    router.selectTab(.home)
                }
        }
    }
}
