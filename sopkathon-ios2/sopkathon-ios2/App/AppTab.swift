//
//  AppTab.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

enum AppTab: CaseIterable {
    case home
    case briefing
    case childList

    var title: String {
        switch self {
        case .home:
            return "홈"
        case .briefing:
            return "브리핑"
        case .childList:
            return "아이관리"
        }
    }

    var symbolName: String {
        switch self {
        case .home:
            return "house.fill"
        case .briefing:
            return "text.bubble.fill"
        case .childList:
            return "person.2.fill"
        }
    }
}
