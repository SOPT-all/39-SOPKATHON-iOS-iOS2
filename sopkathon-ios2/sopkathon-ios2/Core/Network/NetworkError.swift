//
//  NetworkError.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/19/26.
//

enum NetworkError: Error {
    case invalidBaseURL
    case invalidURL
    case encodingFailed(any Error)
    case networkConnection
    case timeout
    case transportFailed(any Error)
    case invalidResponse
    case decodingFailed(any Error)
    case emptyData
    case server(statusCode: Int, code: ServerErrorCode, message: String)
}

enum ServerErrorCode: String {
    case unknown

    init(code: String?) {
        self = code.flatMap(ServerErrorCode.init(rawValue:)) ?? .unknown
    }
}
