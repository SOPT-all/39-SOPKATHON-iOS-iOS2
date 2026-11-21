//
//  CareRecordMapper.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import Foundation

enum CareRecordMapper {
    static func map(_ dto: CareRecordsResponseDTO) -> [CareRecordModel] {
        dto.records.map { map($0) }
    }

    static func map(_ draft: CareRecordDraftModel) -> CreateCareRecordRequestDTO {
        CreateCareRecordRequestDTO(
            childID: draft.childID,
            category: draft.category?.serverValue,
            text: draft.text
        )
    }

    private static func map(_ dto: CareRecordsResponseDTO.Record) -> CareRecordModel {
        CareRecordModel(
            id: dto.recordID,
            childID: dto.childID,
            childName: dto.childName,
            category: CareRecordCategoryModel.allCases.first { $0.serverValue == dto.category },
            recordedAt: recordedAtFormatter.date(
                from: String(dto.recordedAt.prefix(Format.recordedAt.count - Format.quoteCount))
            )
        )
    }

    private static let recordedAtFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Format.localeIdentifier)
        formatter.timeZone = TimeZone(identifier: Format.timeZoneIdentifier)
        formatter.dateFormat = Format.recordedAt
        return formatter
    }()
}

private extension CareRecordMapper {
    enum Format {
        static let recordedAt = "yyyy-MM-dd'T'HH:mm:ss"
        static let quoteCount = 2
        static let localeIdentifier = "en_US_POSIX"
        static let timeZoneIdentifier = "Asia/Seoul"
    }
}

private extension CareRecordCategoryModel {
    var serverValue: String {
        switch self {
        case .feeding:
            return "FEEDING"
        case .meal:
            return "MEAL"
        case .sleep:
            return "SLEEP"
        case .diaper:
            return "DIAPER"
        case .play:
            return "PLAY"
        case .health:
            return "HEALTH"
        }
    }
}
