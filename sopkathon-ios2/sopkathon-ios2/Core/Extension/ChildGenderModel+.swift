//
//  ChildGenderModel+.swift
//  sopkathon-ios2
//
//  Created by bomin on 11/22/26.
//

extension ChildGenderModel {
    var title: String {
        switch self {
        case .male:
            return "남자"
        case .female:
            return "여자"
        }
    }
}
