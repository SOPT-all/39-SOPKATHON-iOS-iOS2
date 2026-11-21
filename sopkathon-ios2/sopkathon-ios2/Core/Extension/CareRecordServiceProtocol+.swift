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
        for child in children.mentioned(in: text) {
            let draft = CareRecordDraftModel(childID: child.id, text: text)
            records += (try? await createCareRecords(draft)) ?? []
        }
        return records
    }
}
