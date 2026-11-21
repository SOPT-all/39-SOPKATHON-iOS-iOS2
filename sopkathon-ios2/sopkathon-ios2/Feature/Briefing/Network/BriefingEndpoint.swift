//
//  BriefingEndpoint.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

import Foundation

enum BriefingEndpoint {
    case fetchDailyBriefings(date: String)
    case createDailyBriefing(CreateBriefingRequestDTO)
    case updateDailyBriefing(briefingID: Int, request: RefineBriefingRequestDTO)
}

extension BriefingEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchDailyBriefings, .createDailyBriefing:
            return "/api/v1/daily-briefings"
        case .updateDailyBriefing(let briefingID, _):
            return "/api/v1/daily-briefings/\(briefingID)/refine"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchDailyBriefings:
            return .get
        case .createDailyBriefing:
            return .post
        case .updateDailyBriefing:
            return .patch
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .fetchDailyBriefings(let date):
            return [URLQueryItem(name: "date", value: date)]
        default:
            return []
        }
    }

    var body: (any Encodable)? {
        switch self {
        case .createDailyBriefing(let request):
            return request
        case .updateDailyBriefing(_, let request):
            return request
        default:
            return nil
        }
    }
}
