//
//  ChildDetailViewModel.swift
//  sopkathon-ios2
//
//  Created by bomin on 11/22/26.
//

import Foundation
import Observation

@Observable
final class ChildDetailViewModel {
    var childName = ""
    var birthDate: Date?
    var gender: ChildGenderModel?
    var parentName = ""
    var parentPhoneNumber = ""
    var relationship: ChildRelationshipModel?
    var notes = ""

    var isValidParentPhoneNumber: Bool {
        parentPhoneNumber.isValidPhoneNumber
    }

    var canSubmit: Bool {
        draft != nil
    }

    private var isSubmitting = false

    private var draft: ChildDraftModel? {
        let childName = childName.trimmingCharacters(in: .whitespacesAndNewlines)
        let parentName = parentName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !childName.isEmpty,
              !parentName.isEmpty,
              isValidParentPhoneNumber,
              let birthDate,
              let gender,
              let relationship else { return nil }

        return ChildDraftModel(
            name: childName,
            birthDate: birthDate,
            gender: gender,
            parentName: parentName,
            parentPhoneNumber: parentPhoneNumber,
            relationship: relationship,
            note: notes
        )
    }

    private let childID: Int
    private let service: any ChildServiceProtocol

    init(childID: Int, service: any ChildServiceProtocol) {
        self.childID = childID
        self.service = service
    }

    func updateChild() async -> Bool {
        guard !isSubmitting, let draft else { return false }

        isSubmitting = true
        defer { isSubmitting = false }

        return (try? await service.updateChild(childID: childID, draft)) != nil
    }
}
