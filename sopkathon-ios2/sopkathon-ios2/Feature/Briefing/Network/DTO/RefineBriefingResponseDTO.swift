//
//  RefineBriefingResponseDTO.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

struct RefineBriefingResponseDTO: Decodable {
    let briefingID: Int
    let content: String

    enum CodingKeys: String, CodingKey {
        case briefingID = "briefingId"
        case content
    }
}
