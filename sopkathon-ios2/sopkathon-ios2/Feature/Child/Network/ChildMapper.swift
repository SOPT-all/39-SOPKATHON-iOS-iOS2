//
//  ChildMapper.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import Foundation

enum ChildMapper {
    static func map(_ dto: ChildrenResponseDTO) -> [ChildModel] {
        dto.children.map { map($0) }
    }

    static func map(_ draft: ChildDraftModel) -> CreateChildRequestDTO {
        CreateChildRequestDTO(
            name: draft.name,
            birthDate: birthDateFormatter.string(from: draft.birthDate),
            gender: draft.gender.serverValue,
            parent: CreateChildRequestDTO.Parent(
                name: draft.parentName,
                phone: phoneDigits(draft.parentPhoneNumber),
                relationship: draft.relationship.serverValue
            ),
            note: note(draft.note)
        )
    }

    static func map(_ draft: ChildDraftModel) -> UpdateChildRequestDTO {
        UpdateChildRequestDTO(
            name: draft.name,
            birthDate: birthDateFormatter.string(from: draft.birthDate),
            gender: draft.gender.serverValue,
            parent: UpdateChildRequestDTO.Parent(
                name: draft.parentName,
                phone: phoneDigits(draft.parentPhoneNumber),
                relationship: draft.relationship.serverValue
            ),
            note: note(draft.note)
        )
    }

    private static func map(_ dto: ChildrenResponseDTO.Child) -> ChildModel {
        ChildModel(id: dto.childID, name: dto.name)
    }

    private static func phoneDigits(_ phoneNumber: String) -> String {
        phoneNumber.filter { $0.isASCII && $0.isNumber }
    }

    private static func note(_ note: String) -> String? {
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedNote.isEmpty ? nil : trimmedNote
    }

    private static let birthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Format.localeIdentifier)
        formatter.timeZone = TimeZone(identifier: Format.timeZoneIdentifier)
        formatter.dateFormat = Format.birthDate
        return formatter
    }()
}

private extension ChildMapper {
    enum Format {
        static let birthDate = "yyyy-MM-dd"
        static let localeIdentifier = "en_US_POSIX"
        static let timeZoneIdentifier = "Asia/Seoul"
    }
}

private extension ChildGenderModel {
    var serverValue: String {
        switch self {
        case .male:
            return "MALE"
        case .female:
            return "FEMALE"
        }
    }
}

private extension ChildRelationshipModel {
    var serverValue: String {
        switch self {
        case .mother:
            return "MOTHER"
        case .father:
            return "FATHER"
        case .guardian:
            return "GUARDIAN"
        }
    }
}
