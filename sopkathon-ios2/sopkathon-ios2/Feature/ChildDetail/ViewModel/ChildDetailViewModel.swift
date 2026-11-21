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
    var gender: String?
    var parentName = ""
    var parentPhoneNumber = ""
    var relationship: String?
    var notes = ""

    var isValidParentPhoneNumber: Bool {
        parentPhoneNumber.isValidPhoneNumber
    }

    var canSubmit: Bool {
        !childName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && birthDate != nil
            && gender != nil
            && !parentName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && isValidParentPhoneNumber
            && relationship != nil
    }

    private let childID: Int

    init(childID: Int) {
        self.childID = childID
    }
}
