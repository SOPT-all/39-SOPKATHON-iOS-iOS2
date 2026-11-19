//
//  BaseService.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/19/26.
//

import Foundation

import Alamofire

protocol BaseServiceProtocol {
    func request<Response: Decodable>(_ endpoint: some Endpoint) async throws -> Response
    func request(_ endpoint: some Endpoint) async throws
}

final class BaseService {
    static let shared = BaseService()

    private let session: Session
    private let decoder = JSONDecoder()

    private var baseURL: URL? {
        let infoValue = Bundle.main.object(forInfoDictionaryKey: InfoKey.baseURL.rawValue)
        guard let urlString = infoValue as? String, !urlString.isEmpty else { return nil }
        return URL(string: urlString)
    }

    init(session: Session = .default) {
        self.session = session
    }

    private func send<Response: Decodable>(
        _ endpoint: some Endpoint
    ) async throws -> BaseResponseDTO<Response> {
        let request = try makeRequest(endpoint)
        NetworkLogger.logRequest(request)

        do {
            let (data, response) = try await perform(request)
            NetworkLogger.logResponse(response, data: data)
            return try decode(data, statusCode: response.statusCode)
        } catch {
            NetworkLogger.logError(error, for: request)
            throw error
        }
    }

    private func makeRequest(_ endpoint: some Endpoint) throws -> URLRequest {
        guard let baseURL else { throw NetworkError.invalidBaseURL }

        var request = try endpoint.makeURLRequest(baseURL: baseURL)
        request.setValue(
            ContentType.json.rawValue,
            forHTTPHeaderField: HeaderType.accept.rawValue
        )
        if request.httpBody != nil {
            request.setValue(
                ContentType.json.rawValue,
                forHTTPHeaderField: HeaderType.contentType.rawValue
            )
        }
        return request
    }

    private func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let response = await session.request(request).serializingData().response

        guard let httpResponse = response.response else {
            throw makeNetworkError(from: response.error)
        }
        return (response.data ?? Data(), httpResponse)
    }

    private func decode<Response: Decodable>(
        _ data: Data,
        statusCode: Int
    ) throws -> BaseResponseDTO<Response> {
        guard StatusCode.success.contains(statusCode) else {
            let errorResponse = try? decoder.decode(ErrorResponseDTO.self, from: data)
            throw NetworkError.server(
                statusCode: statusCode,
                code: ServerErrorCode(code: errorResponse?.code),
                message: errorResponse?.message ?? ""
            )
        }

        do {
            return try decoder.decode(BaseResponseDTO<Response>.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }

    private func makeNetworkError(from error: AFError?) -> any Error {
        guard let error else { return NetworkError.invalidResponse }
        guard !error.isExplicitlyCancelledError else { return CancellationError() }
        guard let urlError = error.underlyingError as? URLError else {
            return NetworkError.transportFailed(error)
        }

        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return NetworkError.networkConnection
        case .timedOut:
            return NetworkError.timeout
        case .cancelled:
            return CancellationError()
        default:
            return NetworkError.transportFailed(urlError)
        }
    }
}

extension BaseService: BaseServiceProtocol {
    func request<Response: Decodable>(_ endpoint: some Endpoint) async throws -> Response {
        let response: BaseResponseDTO<Response> = try await send(endpoint)
        guard let data = response.data else { throw NetworkError.emptyData }
        return data
    }

    func request(_ endpoint: some Endpoint) async throws {
        let _: BaseResponseDTO<EmptyData> = try await send(endpoint)
    }
}

private extension BaseService {
    enum InfoKey: String {
        case baseURL = "BASE_URL"
    }

    enum StatusCode {
        static let success = 200..<300
    }
}
