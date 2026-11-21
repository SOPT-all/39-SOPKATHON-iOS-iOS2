//
//  CareRecordEndpoint.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

import Foundation

enum CareRecordEndpoint {
    case fetchCareRecords(childID: Int, date: String, category: String?, sort: String?)
    case createCareRecord
}

extension CareRecordEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchCareRecords(let childID, _, _, _):
            return "/api/v1/kids/\(childID)/care-records"
        case .createCareRecord:
            return "/api/v1/care-records"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchCareRecords:
            return .get
        case .createCareRecord:
            return .post
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .fetchCareRecords(_, let date, let category, let sort):
            var items = [URLQueryItem(name: "date", value: date)]
            if let category {
                items.append(URLQueryItem(name: "category", value: category))
            }
            if let sort {
                items.append(URLQueryItem(name: "sort", value: sort))
            }
            return items
        case .createCareRecord:
            return []
        }
    }
}
