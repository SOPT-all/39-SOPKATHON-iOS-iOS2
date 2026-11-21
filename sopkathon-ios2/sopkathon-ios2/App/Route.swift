//
//  Route.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

enum Route: Hashable {
    case childRegister
    case childDetail(childID: Int)
    case recordInput(content: String = "")
    case voiceInput
}
