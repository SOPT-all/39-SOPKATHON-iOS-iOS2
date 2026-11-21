//
//  ChildListViewModel.swift
//  sopkathon-ios2
//
//  Created by bomin on 11/22/26.
//

import Foundation
import Observation

@Observable
final class ChildListViewModel {
    var keyword = ""
    private(set) var children: [ChildModel] = []
    private(set) var hasFetched = false

    private var trimmedKeyword: String? {
        let keyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        return keyword.isEmpty ? nil : keyword
    }

    private let service: any ChildServiceProtocol

    init(service: any ChildServiceProtocol) {
        self.service = service
    }

    func fetchChildren() async {
        defer { hasFetched = true }

        guard let children = try? await service.fetchChildren(keyword: trimmedKeyword) else { return }
        self.children = children
    }

    func deleteChild(childID: Int) async {
        guard (try? await service.deleteChild(childID: childID)) != nil else { return }
        children.removeAll { $0.id == childID }
    }
}
