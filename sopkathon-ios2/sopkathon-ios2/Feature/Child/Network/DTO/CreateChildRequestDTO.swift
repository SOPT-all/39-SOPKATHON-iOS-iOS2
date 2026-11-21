//
//  CreateChildRequestDTO.swift
//  sopkathon-ios2
//
//  Created by bomin on 11/22/26.
//

struct CreateChildRequestDTO: Encodable {
    let name: String
    let birthDate: String
    let gender: String
    let parent: Parent
    let note: String?

    enum CodingKeys: String, CodingKey {
        case name
        case birthDate
        case gender
        case parent
        case note
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(birthDate, forKey: .birthDate)
        try container.encode(gender, forKey: .gender)
        try container.encode(parent, forKey: .parent)
        try container.encode(note, forKey: .note)
    }
}

extension CreateChildRequestDTO {
    struct Parent: Encodable {
        let name: String
        let phone: String
        let relationship: String
    }
}
