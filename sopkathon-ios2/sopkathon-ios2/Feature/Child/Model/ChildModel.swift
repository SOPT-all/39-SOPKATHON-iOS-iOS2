//
//  ChildModel.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

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

private enum NameRule {
    static let surnameCount = 1
}
