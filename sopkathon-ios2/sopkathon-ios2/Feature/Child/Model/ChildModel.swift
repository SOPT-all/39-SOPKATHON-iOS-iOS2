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

    var recognitionHints: [String] {
        spokenNames.flatMap { spokenName in
            guard spokenName.last?.hangulJamo?.last != NameRule.emptyFinalConsonant else {
                return [spokenName]
            }
            return [spokenName, spokenName + NameRule.calledSuffix]
        }
    }
}

extension [ChildModel] {
    func mentioned(in text: String) -> [ChildModel] {
        let exactMentions = mentions(in: text) { name in
            text.range(of: spacedPattern(of: name), options: .regularExpression)?.lowerBound
        }
        guard exactMentions.isEmpty else { return exactMentions }

        return mentions(in: text) { name in
            similarPosition(of: name, in: text)
        }
    }

    private func mentions(
        in text: String,
        position: (String) -> String.Index?
    ) -> [ChildModel] {
        let mentions = compactMap { child -> (child: ChildModel, position: String.Index)? in
            let positions = child.spokenNames
                .filter { $0 == child.name || isUniqueSpokenName($0) }
                .compactMap(position)
            guard let position = positions.min() else { return nil }
            return (child, position)
        }
        let duplicatedPositions = Dictionary(grouping: mentions, by: \.position)
            .filter { $0.value.count > 1 }
            .keys

        return mentions
            .filter { !duplicatedPositions.contains($0.position) }
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

    private func similarPosition(of name: String, in text: String) -> String.Index? {
        let nameJamo = name.compactMap(\.hangulJamo)
        guard nameJamo.count == name.count, name.count > 1 else { return nil }

        let characters = [Character](text)
        guard characters.count >= name.count else { return nil }

        for offset in 0...(characters.count - name.count) {
            let windowJamo = characters[offset..<(offset + name.count)].compactMap(\.hangulJamo)
            guard windowJamo.count == name.count else { continue }

            let difference = zip(nameJamo, windowJamo)
                .map { zip($0, $1).filter { $0 != $1 }.count }
                .reduce(0, +)
            guard difference <= NameRule.allowedJamoDifference else { continue }
            return text.index(text.startIndex, offsetBy: offset)
        }
        return nil
    }
}

private extension Character {
    var hangulJamo: [Int]? {
        guard let scalar = unicodeScalars.first,
              unicodeScalars.count == 1,
              NameRule.hangulSyllables.contains(scalar.value) else { return nil }

        let index = Int(scalar.value - NameRule.hangulSyllables.lowerBound)
        return [
            index / NameRule.syllablesPerInitial,
            index % NameRule.syllablesPerInitial / NameRule.finalCount,
            index % NameRule.finalCount
        ]
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
    static let calledSuffix = "이"
    static let emptyFinalConsonant = 0
    static let allowedJamoDifference = 1
    static let hangulSyllables: ClosedRange<UInt32> = 0xAC00...0xD7A3
    static let syllablesPerInitial = 588
    static let finalCount = 28
}
