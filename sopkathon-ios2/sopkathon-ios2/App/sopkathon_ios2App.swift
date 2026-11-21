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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dependency)
        }
    }
}
