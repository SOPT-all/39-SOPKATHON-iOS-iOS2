//
//  BaseResponseDTO.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/19/26.
//

struct BaseResponseDTO<T: Decodable>: Decodable {
    let data: T?
}

struct ErrorResponseDTO: Decodable {
    let code: String
    let message: String
}

struct EmptyData: Decodable {}
