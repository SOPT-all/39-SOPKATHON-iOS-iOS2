//
//  MockChildService.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import Foundation

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

    func fetchChild(childID: Int) async throws -> ChildDetailModel {
        ChildDetailModel(
            id: childID,
            name: "김우진",
            birthDate: Date(timeIntervalSince1970: 1647302400),
            gender: .male,
            parentName: "김민수",
            parentPhoneNumber: "010-1111-2222",
            relationship: .father,
            note: "우유 알레르기가 있습니다."
        )
    }

    func createChild(_ draft: ChildDraftModel) async throws -> Int {
        5
    }

    func updateChild(childID: Int, _ draft: ChildDraftModel) async throws {}

    func deleteChild(childID: Int) async throws {}
}
