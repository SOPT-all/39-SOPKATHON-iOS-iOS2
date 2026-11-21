//
//  AppPreviewConfiguration.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

import Foundation

enum AppPreviewConfiguration {
    static var isBriefingEnabled: Bool {
#if DEBUG
        ProcessInfo.processInfo.arguments.contains("-previewBriefing")
#else
        false
#endif
    }
}
