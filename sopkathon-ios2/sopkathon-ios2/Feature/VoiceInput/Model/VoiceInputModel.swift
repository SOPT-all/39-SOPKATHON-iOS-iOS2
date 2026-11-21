//
//  VoiceInputModel.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import Foundation

struct VoiceInputModel {
    let transcripts: AsyncStream<String>
    let audioLevels: AsyncStream<Float>
}
