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
    @State private var isSplashFinished = false

    init() {
        let dependency = AppDependency(
            mode: AppPreviewConfiguration.isBriefingEnabled ? .mock : .live,
            baseService: BaseService.shared
        )
        let notificationService = LocalNotificationService()
        _dependency = State(initialValue: dependency)
        _notificationService = State(initialValue: notificationService)
        let watchSyncReceiver = WatchSyncReceiver(
            voiceInputService: dependency.voiceInputService,
            careRecordService: dependency.careRecordService,
            childService: dependency.childService,
            notificationService: notificationService
        )
        watchSyncReceiver.activate()
        _watchSyncReceiver = State(initialValue: watchSyncReceiver)
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                RootView()
                    .environment(dependency)
                    .environment(router)
                    .environment(watchSyncReceiver)

                if !isSplashFinished {
                    SplashView {
                        withAnimation(.easeOut(duration: Metric.splashFadeDuration)) {
                            isSplashFinished = true
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
            .task {
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

private enum Metric {
    static let splashFadeDuration: Double = 0.3
}
