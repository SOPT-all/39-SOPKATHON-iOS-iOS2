//
//  ChildService.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

protocol ChildServiceProtocol {
    func fetchChildren(keyword: String?) async throws -> [ChildModel]
    func createChild(_ draft: ChildDraftModel) async throws -> Int
    func updateChild(childID: Int, _ draft: ChildDraftModel) async throws
    func deleteChild(childID: Int) async throws
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

    func createChild(_ draft: ChildDraftModel) async throws -> Int {
        let request: CreateChildRequestDTO = ChildMapper.map(draft)
        let response: ChildIDResponseDTO = try await baseService.request(
            ChildEndpoint.createChild(request)
        )
        return response.childID
    }

    func updateChild(childID: Int, _ draft: ChildDraftModel) async throws {
        let request: UpdateChildRequestDTO = ChildMapper.map(draft)
        try await baseService.request(ChildEndpoint.updateChild(childID: childID, request))
    }

    func deleteChild(childID: Int) async throws {
        try await baseService.request(ChildEndpoint.deleteChild(childID: childID))
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
