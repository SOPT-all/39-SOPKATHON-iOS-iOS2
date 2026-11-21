//
//  AppTab.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

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

    var iconSize: CGFloat {
        switch self {
        case .home, .briefing:
            return 24
        case .childList:
            return 30
        }
    }

    func icon(isSelected: Bool) -> ImageResource {
        switch self {
        case .home:
            return isSelected ? .iconHomeOn : .iconHomeOff
        case .briefing:
            return isSelected ? .iconBriefingOn : .iconBriefingOff
        case .childList:
            return isSelected ? .iconManageOn : .iconManageOff
        }
    }
}
