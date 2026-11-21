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
            recordedKidNames: dto.recordedKidNames,
            kids: dto.kids.map { map($0) }
        )
    }

    static func map(_ dto: CreateBriefingResponseDTO) -> BriefingMessageModel {
        BriefingMessageModel(id: dto.briefingID, content: dto.content)
    }

    static func map(_ dto: RefineBriefingResponseDTO) -> BriefingMessageModel {
        BriefingMessageModel(id: dto.briefingID, content: dto.content)
    }

    private static func map(_ dto: BriefingResponseDTO.Kid) -> BriefingKidModel {
        BriefingKidModel(
            id: dto.kidID,
            name: dto.name,
            age: dto.age,
            recordCount: dto.recordCount,
            summary: categoryOrder.compactMap { category in
                guard let count = dto.summary[category.serverValue] else { return nil }
                return BriefingSummaryItemModel(category: category, count: count)
            },
            parent: dto.parent.map { map($0) },
            briefing: dto.briefing.map { map($0) }
        )
    }

    private static func map(_ dto: BriefingResponseDTO.Parent) -> BriefingParentModel {
        BriefingParentModel(name: dto.name, phone: dto.phone)
    }

    private static func map(_ dto: BriefingResponseDTO.Briefing) -> BriefingMessageModel {
        BriefingMessageModel(id: dto.briefingID, content: dto.content)
    }

    private static let categoryOrder: [CareRecordCategoryModel] = [
        .feeding, .meal, .sleep, .diaper, .play, .health
    ]
}

private extension CareRecordCategoryModel {
    var serverValue: String {
        switch self {
        case .feeding: "FEEDING"
        case .meal: "MEAL"
        case .sleep: "SLEEP"
        case .diaper: "DIAPER"
        case .play: "PLAY"
        case .health: "HEALTH"
        }
    }
}
