//
//  AppRouter.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

import Observation

@Observable
final class AppRouter {
    var path: [Route] = []

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
