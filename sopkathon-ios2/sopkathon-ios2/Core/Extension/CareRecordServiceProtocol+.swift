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
        let mentionedChildren = children.mentioned(in: text)
        #if DEBUG
        print("[Voice] 인식된 문장: \(text)")
        print("[Voice] 등록된 아이: \(children.map(\.name))")
        print("[Voice] 문장에서 찾은 아이: \(mentionedChildren.map(\.name))")
        #endif

        var records: [CareRecordModel] = []
        for child in mentionedChildren {
            let draft = CareRecordDraftModel(childID: child.id, text: text)
            records += (try? await createCareRecords(draft)) ?? []
        }
        return records
    }
}
