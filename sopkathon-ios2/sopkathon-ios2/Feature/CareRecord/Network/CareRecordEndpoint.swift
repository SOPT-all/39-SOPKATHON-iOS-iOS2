//
//  CareRecordEndpoint.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

enum CareRecordEndpoint {
    case createCareRecord(CreateCareRecordRequestDTO)
}

extension CareRecordEndpoint: Endpoint {
    var path: String {
        switch self {
        case .createCareRecord:
            return "/api/v1/records"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createCareRecord:
            return .post
        }
    }

    var body: (any Encodable)? {
        switch self {
        case .createCareRecord(let request):
            return request
        }
    }
}
