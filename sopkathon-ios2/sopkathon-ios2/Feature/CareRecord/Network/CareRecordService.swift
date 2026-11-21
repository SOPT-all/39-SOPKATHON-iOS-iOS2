//
//  CareRecordService.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

protocol CareRecordServiceProtocol {
    func createCareRecords(_ draft: CareRecordDraftModel) async throws -> [CareRecordModel]
}

final class CareRecordService {
    private let baseService: any BaseServiceProtocol

    init(baseService: any BaseServiceProtocol) {
        self.baseService = baseService
    }
}

extension CareRecordService: CareRecordServiceProtocol {
    func createCareRecords(_ draft: CareRecordDraftModel) async throws -> [CareRecordModel] {
        let response: CareRecordsResponseDTO = try await baseService.request(
            CareRecordEndpoint.createCareRecord(CareRecordMapper.map(draft))
        )
        return CareRecordMapper.map(response)
    }
}

extension AppDependency {
    var careRecordService: any CareRecordServiceProtocol {
        switch mode {
        case .live:
            return CareRecordService(baseService: baseService)
        case .mock:
            return MockCareRecordService()
        }
    }
}
