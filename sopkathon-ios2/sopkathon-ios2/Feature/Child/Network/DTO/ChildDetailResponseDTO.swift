//
//  ChildDetailResponseDTO.swift
//  sopkathon-ios2
//
//  Created by bomin on 11/22/26.
//

struct ChildDetailResponseDTO: Decodable {
    let childID: Int
    let name: String
    let birthDate: String
    let gender: String
    let note: String?
    let parent: Parent?

    enum CodingKeys: String, CodingKey {
        case childID = "kidId"
        case name
        case birthDate
        case gender
        case note
        case parent
    }
}

extension ChildDetailResponseDTO {
    struct Parent: Decodable {
        let name: String
        let phone: String
        let relationship: String
    }
}
