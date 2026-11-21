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
}
