//
//  ChildDetailView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

import SwiftUI

struct ChildDetailView: View {
    let childID: Int

    var body: some View {
        Text("아이 상세/수정 \(childID)")
            .typography(.subHeader2)
    }
}
