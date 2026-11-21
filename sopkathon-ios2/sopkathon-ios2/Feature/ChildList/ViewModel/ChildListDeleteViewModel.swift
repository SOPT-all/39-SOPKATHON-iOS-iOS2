//
//  ChildListDeleteViewModel.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import Observation

@Observable
final class ChildListDeleteViewModel {
    private let childID: Int
    private let service: any ChildServiceProtocol

    init(childID: Int, service: any ChildServiceProtocol) {
        self.childID = childID
        self.service = service
    }

    func deleteChild() async {
        try? await service.deleteChild(childID: childID)
    }
}
