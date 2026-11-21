//
//  AppSheet.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

enum AppSheet: Equatable {
    case voiceInput(teacherName: String)
    case childDelete(child: ChildModel)

    var isCentered: Bool {
        switch self {
        case .voiceInput:
            return false
        case .childDelete:
            return true
        }
    }
}
