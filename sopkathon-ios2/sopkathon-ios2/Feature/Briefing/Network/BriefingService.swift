//
//  BriefingService.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

protocol BriefingServiceProtocol {
    func fetchDailyBriefings(date: String) async throws -> BriefingModel
    func createDailyBriefing(kidID: Int, date: String) async throws -> BriefingMessageModel
}

final class BriefingService {
    private let baseService: any BaseServiceProtocol

    init(baseService: any BaseServiceProtocol) {
        self.baseService = baseService
    }
}

extension BriefingService: BriefingServiceProtocol {
    func fetchDailyBriefings(date: String) async throws -> BriefingModel {
        let response: BriefingResponseDTO = try await baseService.request(
            BriefingEndpoint.fetchDailyBriefings(date: date)
        )
        return BriefingMapper.map(response)
    }

    func createDailyBriefing(kidID: Int, date: String) async throws -> BriefingMessageModel {
        let request = CreateBriefingRequestDTO(kidID: kidID, date: date)
        let response: CreateBriefingResponseDTO = try await baseService.request(
            BriefingEndpoint.createDailyBriefing(request)
        )
        return BriefingMapper.map(response)
    }
}

extension AppDependency {
    var briefingService: any BriefingServiceProtocol {
        switch mode {
        case .live:
            return BriefingService(baseService: baseService)
        case .mock:
            return MockBriefingService()
        }
    }
}
