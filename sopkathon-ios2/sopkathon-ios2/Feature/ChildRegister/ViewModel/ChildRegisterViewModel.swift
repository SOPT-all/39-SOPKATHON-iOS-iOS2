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
    var gender: ChildGenderModel?
    var parentName = ""
    var parentPhoneNumber = ""
    var relationship: ChildRelationshipModel?
    var notes = ""

    var isValidChildName: Bool {
        !trimmedChildName.isEmpty
    }

    var isValidParentName: Bool {
        !trimmedParentName.isEmpty
    }

    var isValidParentPhoneNumber: Bool {
        parentPhoneNumber.isValidPhoneNumber
    }

    var canSubmit: Bool {
        draft != nil
    }

    private var isSubmitting = false

    private var trimmedChildName: String {
        childName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedParentName: String {
        parentName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var draft: ChildDraftModel? {
        guard isValidChildName,
              isValidParentName,
              isValidParentPhoneNumber,
              let birthDate,
              let gender,
              let relationship else { return nil }

        return ChildDraftModel(
            name: trimmedChildName,
            birthDate: birthDate,
            gender: gender,
            parentName: trimmedParentName,
            parentPhoneNumber: parentPhoneNumber,
            relationship: relationship,
            note: notes
        )
    }

    private let service: any ChildServiceProtocol

    init(service: any ChildServiceProtocol) {
        self.service = service
    }

    func createChild() async -> Bool {
        guard !isSubmitting, let draft else { return false }

        isSubmitting = true
        defer { isSubmitting = false }

        return (try? await service.createChild(draft)) != nil
    }
}
