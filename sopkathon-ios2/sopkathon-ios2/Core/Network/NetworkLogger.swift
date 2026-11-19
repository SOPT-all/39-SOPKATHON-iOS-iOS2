//
//  NetworkLogger.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/19/26.
//

import Foundation

enum NetworkLogger {
    #if DEBUG
    private static let maskedValue = "***"
    #endif

    static func logRequest(_ request: URLRequest) {
        #if DEBUG
        let method = request.httpMethod ?? ""
        let url = request.url?.absoluteString ?? ""
        let headers = (request.allHTTPHeaderFields ?? [:])
            .keys
            .sorted()
            .map { "\($0): \(maskedValue)" }
            .joined(separator: ", ")

        print("[Request] \(method) \(url)")
        print("[Headers] \(headers)")
        if let body = request.httpBody {
            print("[Body] \(String(decoding: body, as: UTF8.self))")
        }
        #endif
    }

    static func logResponse(_ response: HTTPURLResponse, data: Data) {
        #if DEBUG
        let url = response.url?.absoluteString ?? ""

        print("[Response] \(response.statusCode) \(url)")
        print("[Body] \(String(decoding: data, as: UTF8.self))")
        #endif
    }

    static func logError(_ error: any Error, for request: URLRequest) {
        #if DEBUG
        let url = request.url?.absoluteString ?? ""

        print("[Error] \(url) \(error)")
        #endif
    }
}
