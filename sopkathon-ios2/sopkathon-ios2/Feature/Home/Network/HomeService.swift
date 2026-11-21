//
//  HomeService.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import Foundation

protocol HomeServiceProtocol {
    func fetchHome() async throws -> HomeModel
}

extension AppDependency {
    var homeService: any HomeServiceProtocol {
        switch mode {
        case .live, .mock:
            return MockHomeService()
        }
    }
}
