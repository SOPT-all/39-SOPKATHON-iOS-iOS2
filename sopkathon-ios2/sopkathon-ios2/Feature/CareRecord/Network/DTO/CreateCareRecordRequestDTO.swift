//
//  CreateCareRecordRequestDTO.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

struct CreateCareRecordRequestDTO: Encodable {
    let childID: Int?
    let category: String?
    let text: String

    enum CodingKeys: String, CodingKey {
        case childID = "kidId"
        case category
        case text
    }
}
