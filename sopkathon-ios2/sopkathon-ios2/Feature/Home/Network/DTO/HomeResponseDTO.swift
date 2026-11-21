//
//  HomeResponseDTO.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import Foundation

struct HomeResponseDTO: Decodable {
    let teacherName: String
    let unrecordedKids: [Kid]
    let todayRecords: [Record]

    enum CodingKeys: String, CodingKey {
        case teacherName = "name"
        case unrecordedKids
        case todayRecords
    }
}

extension HomeResponseDTO {
    struct Kid: Decodable {
        let kidID: Int
        let kidName: String

        enum CodingKeys: String, CodingKey {
            case kidID = "kidId"
            case kidName
        }
    }

    struct Record: Decodable {
        let recordID: Int
        let kidName: String
        let colorID: Int
        let category: String
        let createdAt: String

        enum CodingKeys: String, CodingKey {
            case recordID = "recordId"
            case kidName
            case colorID = "colorId"
            case category
            case createdAt
        }
    }
}
