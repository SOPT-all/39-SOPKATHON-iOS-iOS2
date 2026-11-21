//
//  Route.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

enum Route: Hashable {
    case childRegister
    case childDetail(childID: Int)
    case recordInput
    case voiceInput
    case recordList(childID: Int)
    case recordEdit(recordID: Int)
    case briefing
    case sendTarget
    case sendConfirm
    case sendResult
    case sendHistory
}
