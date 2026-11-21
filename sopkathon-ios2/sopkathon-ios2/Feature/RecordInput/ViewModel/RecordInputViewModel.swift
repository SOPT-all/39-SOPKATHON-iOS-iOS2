//
//  RecordInputViewModel.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import Foundation
import Observation

@Observable
final class RecordInputViewModel {
    var content = ""
    var selectedChild: ChildModel?
    private(set) var selectedCategory: CareRecordCategoryModel?
    private(set) var children: [ChildModel] = []

    var canSave: Bool {
        selectedChild != nil && selectedCategory != nil && !trimmedContent.isEmpty
    }

    private var isSaving = false

    private var trimmedContent: String {
        content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private let childService: any ChildServiceProtocol
    private let careRecordService: any CareRecordServiceProtocol

    init(
        childService: any ChildServiceProtocol,
        careRecordService: any CareRecordServiceProtocol
    ) {
        self.childService = childService
        self.careRecordService = careRecordService
    }

    func fetchChildren() async {
        guard let children = try? await childService.fetchChildren(keyword: nil) else { return }
        self.children = children
    }

    func selectCategory(_ category: CareRecordCategoryModel) {
        selectedCategory = category
    }

    func saveRecord() async -> Bool {
        guard canSave, !isSaving, let selectedChild, let selectedCategory else { return false }

        isSaving = true
        defer { isSaving = false }

        let draft = CareRecordDraftModel(
            childID: selectedChild.id,
            category: selectedCategory,
            text: trimmedContent
        )
        return (try? await careRecordService.createCareRecords(draft)) != nil
    }
}
