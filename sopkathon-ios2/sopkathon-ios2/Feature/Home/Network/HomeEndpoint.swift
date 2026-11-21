//
//  HomeEndpoint.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

enum HomeEndpoint {
    case fetchHome
}

extension HomeEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchHome:
            return "/api/v1/home"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchHome:
            return .get
        }
    }
}
