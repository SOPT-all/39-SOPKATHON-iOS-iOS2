//
//  MockPhoneSyncService.swift
//  SopkathonWatch
//
//  Created by h2e on 11/22/26.
//

import Foundation

struct MockPhoneSyncService {}

extension MockPhoneSyncService: PhoneSyncServiceProtocol {
    func sendRecording(at url: URL) async -> Bool {
        try? await Task.sleep(for: Sample.transferDuration)
        return true
    }
}

private extension MockPhoneSyncService {
    enum Sample {
        static let transferDuration: Duration = .seconds(2)
    }
}
