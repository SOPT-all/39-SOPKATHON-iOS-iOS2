//
//  BriefingResponseDTO.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

struct BriefingResponseDTO: Decodable {
    let date: String
    let recordedKidCount: Int
    let kids: [Kid]
}

extension BriefingResponseDTO {
    struct Kid: Decodable {
        let kidID: Int
        let name: String
        let age: Int
        let recordCount: Int
        let summary: Summary
        let parent: Parent
        let briefing: Briefing?

        enum CodingKeys: String, CodingKey {
            case kidID = "kidId"
            case name
            case age
            case recordCount
            case summary
            case parent
            case briefing
        }
    }

    struct Summary: Decodable {
        let feeding: Int
        let sleep: Int
        let diaper: Int

        enum CodingKeys: String, CodingKey {
            case feeding = "FEEDING"
            case sleep = "SLEEP"
            case diaper = "DIAPER"
        }
    }

    struct Parent: Decodable {
        let name: String
        let phone: String
    }

    struct Briefing: Decodable {
        let briefingID: Int
        let content: String

        enum CodingKeys: String, CodingKey {
            case briefingID = "briefingId"
            case content
        }
    }
}
