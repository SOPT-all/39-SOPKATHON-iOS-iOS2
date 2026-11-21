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

final class HomeService {
    private let baseService: any BaseServiceProtocol

    init(baseService: any BaseServiceProtocol) {
        self.baseService = baseService
    }
}

extension HomeService: HomeServiceProtocol {
    func fetchHome() async throws -> HomeModel {
        let response: HomeResponseDTO = try await baseService.request(HomeEndpoint.fetchHome)
        return HomeMapper.map(response)
    }
}

extension AppDependency {
    var homeService: any HomeServiceProtocol {
        switch mode {
        case .live:
            return HomeService(baseService: baseService)
        case .mock:
            return MockHomeService()
        }
    }
}
