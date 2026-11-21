//
//  ChildMapper.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

enum ChildMapper {
    static func map(_ dto: ChildrenResponseDTO) -> [ChildModel] {
        dto.children.map { map($0) }
    }

    private static func map(_ dto: ChildrenResponseDTO.Child) -> ChildModel {
        ChildModel(id: dto.childID, name: dto.name)
    }
}
