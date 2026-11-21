//
//  CareRecordServiceProtocol+.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

extension CareRecordServiceProtocol {
    func createCareRecords(
        fromSpokenText text: String,
        mentioning children: [ChildModel]
    ) async -> [CareRecordModel] {
        var records: [CareRecordModel] = []
        for mention in children.mentions(in: text) {
            let mentionedCategory = CareRecordCategoryModel.mentioned(in: mention.text)
            let draft = CareRecordDraftModel(
                childID: mention.child.id,
                category: mentionedCategory ?? .mentioned(in: text),
                text: mentionedCategory == nil ? text : mention.text
            )
            records += (try? await createCareRecords(draft)) ?? []
        }
        return records
    }
}
