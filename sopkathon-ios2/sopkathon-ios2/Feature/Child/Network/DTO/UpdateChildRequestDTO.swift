//
//  UpdateChildRequestDTO.swift
//  sopkathon-ios2
//
//  Created by bomin on 11/22/26.
//

struct UpdateChildRequestDTO: Encodable {
    let name: String?
    let birthDate: String?
    let gender: String?
    let parent: Parent?
    let note: String?
}

extension UpdateChildRequestDTO {
    struct Parent: Encodable {
        let name: String?
        let phone: String?
        let relationship: String?
    }
}
