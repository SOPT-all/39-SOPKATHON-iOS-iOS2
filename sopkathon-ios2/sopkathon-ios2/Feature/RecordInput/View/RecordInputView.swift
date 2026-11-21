//
//  RecordInputView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

import SwiftUI

struct RecordInputView: View {
    @State private var viewModel: RecordInputViewModel

    init(viewModel: RecordInputViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            MultiLineTextField(title: Title.content, text: $viewModel.content)
                .padding(Metric.padding)
        }
    }
}

private extension RecordInputView {
    enum Metric {
        static let padding: CGFloat = 20
    }

    enum Title {
        static let content = "기록 내용"
    }
}
