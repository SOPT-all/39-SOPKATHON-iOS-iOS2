//
//  CreateBriefingRequestDTO.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

struct CreateBriefingRequestDTO: Encodable {
    let kidID: Int
    let date: String

    enum CodingKeys: String, CodingKey {
        case kidID = "kidId"
        case date
    }
}
