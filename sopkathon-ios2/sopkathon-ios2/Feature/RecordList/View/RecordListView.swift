//
//  RecordListView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

import SwiftUI

struct RecordListView: View {
    let childID: Int

    var body: some View {
        Text("아이별 기록 목록 \(childID)")
            .typography(.subHeader2)
    }
}
