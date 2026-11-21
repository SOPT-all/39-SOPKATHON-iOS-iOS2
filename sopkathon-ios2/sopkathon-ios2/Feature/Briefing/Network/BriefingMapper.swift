//
//  BriefingMapper.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

enum BriefingMapper {
    static func map(_ dto: BriefingResponseDTO) -> BriefingModel {
        BriefingModel(
            date: dto.date,
            recordedKidCount: dto.recordedKidCount,
            kids: dto.kids.map { map($0) }
        )
    }

    static func map(_ dto: CreateBriefingResponseDTO) -> BriefingMessageModel {
        BriefingMessageModel(id: dto.briefingID, content: dto.content)
    }

    private static func map(_ dto: BriefingResponseDTO.Kid) -> BriefingKidModel {
        BriefingKidModel(
            id: dto.kidID,
            name: dto.name,
            age: dto.age,
            recordCount: dto.recordCount,
            summary: map(dto.summary),
            parent: map(dto.parent),
            briefing: dto.briefing.map { map($0) }
        )
    }

    private static func map(_ dto: BriefingResponseDTO.Summary) -> BriefingSummaryModel {
        BriefingSummaryModel(
            feeding: dto.feeding,
            sleep: dto.sleep,
            diaper: dto.diaper
        )
    }

    private static func map(_ dto: BriefingResponseDTO.Parent) -> BriefingParentModel {
        BriefingParentModel(name: dto.name, phone: dto.phone)
    }

    private static func map(_ dto: BriefingResponseDTO.Briefing) -> BriefingMessageModel {
        BriefingMessageModel(id: dto.briefingID, content: dto.content)
    }
}
