//
//  CareRecordCategoryModel+.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

extension CareRecordCategoryModel {
    var icon: ImageResource {
        switch self {
        case .feeding:
            return .iconFeeding
        case .meal:
            return .iconMeals
        case .sleep:
            return .iconSleep
        case .diaper:
            return .iconDiapering
        case .play:
            return .iconPlay
        case .health:
            return .iconHealth
        }
    }
}
