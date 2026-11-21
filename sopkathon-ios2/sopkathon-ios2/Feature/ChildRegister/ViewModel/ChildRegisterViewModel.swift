//
//  ChildRegisterViewModel.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

import Foundation
import Observation

@Observable
final class ChildRegisterViewModel {
    var childName = ""
    var birthDate: Date?
    var gender: String?
    var parentName = ""
    var parentPhoneNumber = "" {
        didSet {
            let formattedPhoneNumber = parentPhoneNumber.formattedPhoneNumber
            guard parentPhoneNumber != formattedPhoneNumber else { return }
            parentPhoneNumber = formattedPhoneNumber
        }
    }
    var relationship: String?
    var notes = ""

    var isValidChildName: Bool {
        !childName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isValidParentName: Bool {
        !parentName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isValidParentPhoneNumber: Bool {
        parentPhoneNumber.isValidPhoneNumber
    }

    var canSubmit: Bool {
        isValidChildName
            && birthDate != nil
            && hasGender
            && isValidParentName
            && isValidParentPhoneNumber
            && hasRelationship
    }

    private var hasGender: Bool {
        guard let gender else { return false }
        return !gender.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var hasRelationship: Bool {
        guard let relationship else { return false }
        return !relationship.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
