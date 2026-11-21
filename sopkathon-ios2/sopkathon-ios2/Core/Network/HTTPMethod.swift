//
//  HTTPMethod.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/19/26.
//

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum HeaderType: String {
    case contentType = "Content-Type"
    case accept = "Accept"
    case memberID = "Member-Id"
}

enum ContentType: String {
    case json = "application/json"
}
