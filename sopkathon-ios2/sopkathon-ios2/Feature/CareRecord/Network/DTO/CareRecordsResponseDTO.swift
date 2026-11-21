//
//  CareRecordsResponseDTO.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

struct CareRecordsResponseDTO: Decodable {
    let records: [Record]
}

extension CareRecordsResponseDTO {
    struct Record: Decodable {
        let recordID: Int
        let childID: Int
        let childName: String
        let category: String
        let recordedAt: String

        enum CodingKeys: String, CodingKey {
            case recordID = "recordId"
            case childID = "kidId"
            case childName = "kidName"
            case category
            case recordedAt
        }
    }
}
