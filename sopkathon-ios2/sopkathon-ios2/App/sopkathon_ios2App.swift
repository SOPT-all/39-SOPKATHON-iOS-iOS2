//
//  sopkathon_ios2App.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/19/26.
//

import SwiftUI

@main
struct sopkathon_ios2App: App {
    @State private var dependency = AppDependency(mode: .live, baseService: BaseService.shared)
    @State private var router = AppRouter()
    @State private var isSplashFinished = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                RootView()
                    .environment(dependency)
                    .environment(router)

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
        }
    }
}

private enum Metric {
    static let splashFadeDuration: Double = 0.3
}
