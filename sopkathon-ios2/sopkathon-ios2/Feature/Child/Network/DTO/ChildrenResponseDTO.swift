//
//  ChildrenResponseDTO.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

struct ChildrenResponseDTO: Decodable {
    let children: [Child]

    enum CodingKeys: String, CodingKey {
        case children = "kids"
    }
}

extension ChildrenResponseDTO {
    struct Child: Decodable {
        let childID: Int
        let name: String

        enum CodingKeys: String, CodingKey {
            case childID = "kidId"
            case name
        }
    }
}
