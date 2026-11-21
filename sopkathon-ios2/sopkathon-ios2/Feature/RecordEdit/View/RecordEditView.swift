//
//  RecordEditView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

import SwiftUI

struct RecordEditView: View {
    let recordID: Int

    var body: some View {
        Text("기록 수정 \(recordID)")
            .typography(.subHeader2)
    }
}
