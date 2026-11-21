//
//  MockChildService.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

struct MockChildService {}

extension MockChildService: ChildServiceProtocol {
    func fetchChildren(keyword: String?) async throws -> [ChildModel] {
        let children = [
            ChildModel(id: 1, name: "김우진"),
            ChildModel(id: 2, name: "김준혁"),
            ChildModel(id: 3, name: "신예준"),
            ChildModel(id: 4, name: "이하연")
        ]
        guard let keyword else { return children }
        return children.filter { $0.name.contains(keyword) }
    }
}
