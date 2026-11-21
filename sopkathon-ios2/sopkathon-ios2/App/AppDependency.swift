//
//  AppDependency.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

import Observation

@Observable
final class AppDependency {
    enum Mode {
        case live
        case mock
    }

    let mode: Mode
    let baseService: any BaseServiceProtocol

    init(mode: Mode, baseService: any BaseServiceProtocol) {
        self.mode = mode
        self.baseService = baseService
    }
}
