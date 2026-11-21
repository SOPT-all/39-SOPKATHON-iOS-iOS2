//
//  ChildEndpoint.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

import Foundation

enum ChildEndpoint {
    case createChild(CreateChildRequestDTO)
    case updateChild(childID: Int, UpdateChildRequestDTO)
    case deleteChild(childID: Int)
    case fetchChildren(keyword: String?)
}

extension ChildEndpoint: Endpoint {
    var path: String {
        switch self {
        case .createChild, .fetchChildren:
            return "/api/v1/kids"
        case .updateChild(let childID, _), .deleteChild(let childID):
            return "/api/v1/kids/\(childID)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createChild:
            return .post
        case .updateChild:
            return .patch
        case .deleteChild:
            return .delete
        case .fetchChildren:
            return .get
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .fetchChildren(let keyword):
            guard let keyword else { return [] }
            return [URLQueryItem(name: "keyword", value: keyword)]
        default:
            return []
        }
    }

    var body: (any Encodable)? {
        switch self {
        case .createChild(let request):
            return request
        case .updateChild(_, let request):
            return request
        case .deleteChild, .fetchChildren:
            return nil
        }
    }
}
