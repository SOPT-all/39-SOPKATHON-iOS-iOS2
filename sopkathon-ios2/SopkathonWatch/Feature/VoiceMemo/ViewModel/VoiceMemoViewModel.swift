//
//  VoiceMemoViewModel.swift
//  SopkathonWatch
//
//  Created by h2e on 11/22/26.
//

import Foundation
import Observation

@Observable
final class VoiceMemoViewModel {
    private(set) var savedRecords: [CareRecordModel] = []

    private let service: any CareRecordServiceProtocol

    init(service: any CareRecordServiceProtocol) {
        self.service = service
    }

    func saveMemo(_ memo: String) async {
        let text = memo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty,
              let records = try? await service.createCareRecords(CareRecordDraftModel(text: text))
        else { return }
        savedRecords = records
    }
}
