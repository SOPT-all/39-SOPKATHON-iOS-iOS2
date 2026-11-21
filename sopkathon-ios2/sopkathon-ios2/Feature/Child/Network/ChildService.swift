//
//  ChildService.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

protocol ChildServiceProtocol {
    func fetchChildren(keyword: String?) async throws -> [ChildModel]
}

final class ChildService {
    private let baseService: any BaseServiceProtocol

    init(baseService: any BaseServiceProtocol) {
        self.baseService = baseService
    }
}

extension ChildService: ChildServiceProtocol {
    func fetchChildren(keyword: String?) async throws -> [ChildModel] {
        let response: ChildrenResponseDTO = try await baseService.request(
            ChildEndpoint.fetchChildren(keyword: keyword)
        )
        return ChildMapper.map(response)
    }
}

extension AppDependency {
    var childService: any ChildServiceProtocol {
        switch mode {
        case .live:
            return ChildService(baseService: baseService)
        case .mock:
            return MockChildService()
        }
    }
}
