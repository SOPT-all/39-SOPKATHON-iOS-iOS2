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
    private let phoneSyncService: any PhoneSyncServiceProtocol

    init(
        service: any CareRecordServiceProtocol,
        phoneSyncService: any PhoneSyncServiceProtocol
    ) {
        self.service = service
        self.phoneSyncService = phoneSyncService
    }

    func saveMemo(_ memo: String) async {
        let text = memo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty,
              let records = try? await service.createCareRecords(CareRecordDraftModel(text: text))
        else { return }
        savedRecords = records
        phoneSyncService.notifyCareRecordSaved()
    }
}
