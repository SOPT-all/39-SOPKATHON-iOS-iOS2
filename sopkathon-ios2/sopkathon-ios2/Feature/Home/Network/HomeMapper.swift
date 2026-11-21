//
//  HomeMapper.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import Foundation

enum HomeMapper {
    static func map(_ dto: HomeResponseDTO) -> HomeModel {
        HomeModel(
            teacherName: dto.teacherName,
            unrecordedChildren: dto.unrecordedKids.map { map($0) },
            records: dto.todayRecords.compactMap { map($0) }
        )
    }

    private static func map(_ dto: HomeResponseDTO.Kid) -> HomeChildModel {
        HomeChildModel(id: dto.kidID, name: dto.kidName)
    }

    private static func map(_ dto: HomeResponseDTO.Record) -> HomeRecordModel? {
        guard let category = category(from: dto.category),
              let recordedAt = createdAtFormatter.date(from: dto.createdAt) else { return nil }

        return HomeRecordModel(
            id: dto.recordID,
            childName: dto.kidName,
            colorID: dto.colorID,
            category: category,
            recordedAt: recordedAt
        )
    }

    private static func category(from serverValue: String) -> CareRecordCategoryModel? {
        switch serverValue {
        case "FEEDING":
            return .feeding
        case "MEAL":
            return .meal
        case "SLEEP":
            return .sleep
        case "DIAPER":
            return .diaper
        case "PLAY":
            return .play
        case "HEALTH":
            return .health
        default:
            return nil
        }
    }

    private static let createdAtFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Format.localeIdentifier)
        formatter.timeZone = TimeZone(identifier: Format.timeZoneIdentifier)
        formatter.dateFormat = Format.createdAt
        return formatter
    }()
}

private extension HomeMapper {
    enum Format {
        static let createdAt = "yyyy-MM-dd'T'HH:mm:ss"
        static let localeIdentifier = "en_US_POSIX"
        static let timeZoneIdentifier = "Asia/Seoul"
    }
}
