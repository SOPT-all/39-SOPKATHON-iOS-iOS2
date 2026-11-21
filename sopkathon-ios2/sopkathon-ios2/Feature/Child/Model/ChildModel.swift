//
//  ChildModel.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import Foundation

struct ChildModel: Identifiable, Hashable {
    let id: Int
    let name: String
}

extension ChildModel {
    var spokenNames: [String] {
        guard name.count > NameRule.surnameCount + 1 else { return [name] }
        return [name, String(name.dropFirst(NameRule.surnameCount))]
    }
}

extension [ChildModel] {
    func mentioned(in text: String) -> [ChildModel] {
        compactMap { child -> (child: ChildModel, position: String.Index)? in
            let positions = child.spokenNames
                .filter { $0 == child.name || isUniqueSpokenName($0) }
                .compactMap { text.range(of: spacedPattern(of: $0), options: .regularExpression) }
                .map(\.lowerBound)
            guard let position = positions.min() else { return nil }
            return (child, position)
        }
        .sorted { $0.position < $1.position }
        .map(\.child)
    }

    private func isUniqueSpokenName(_ spokenName: String) -> Bool {
        filter { $0.spokenNames.contains(spokenName) }.count == 1
    }

    private func spacedPattern(of name: String) -> String {
        name.map { NSRegularExpression.escapedPattern(for: String($0)) }
            .joined(separator: NameRule.spacePattern)
    }
}

struct ChildDetailModel {
    let id: Int
    let name: String
    let birthDate: Date?
    let gender: ChildGenderModel?
    let parentName: String
    let parentPhoneNumber: String
    let relationship: ChildRelationshipModel?
    let note: String
}

struct ChildDraftModel {
    let name: String
    let birthDate: Date
    let gender: ChildGenderModel
    let parentName: String
    let parentPhoneNumber: String
    let relationship: ChildRelationshipModel
    let note: String
}

enum ChildGenderModel: CaseIterable {
    case male
    case female
}

enum ChildRelationshipModel: CaseIterable {
    case mother
    case father
    case guardian
}

private enum NameRule {
    static let surnameCount = 1
    static let spacePattern = "\\s*"
}
