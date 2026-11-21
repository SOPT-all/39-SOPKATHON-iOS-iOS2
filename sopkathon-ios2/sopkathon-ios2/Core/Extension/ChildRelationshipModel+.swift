//
//  ChildRelationshipModel+.swift
//  sopkathon-ios2
//
//  Created by bomin on 11/22/26.
//

extension ChildRelationshipModel {
    var title: String {
        switch self {
        case .mother:
            return "엄마"
        case .father:
            return "아빠"
        case .guardian:
            return "보호자"
        }
    }
}
