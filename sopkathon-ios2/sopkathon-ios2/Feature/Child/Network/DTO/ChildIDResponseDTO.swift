//
//  ChildIDResponseDTO.swift
//  sopkathon-ios2
//
//  Created by bomin on 11/22/26.
//

struct ChildIDResponseDTO: Decodable {
    let childID: Int

    enum CodingKeys: String, CodingKey {
        case childID = "kidId"
    }
}
