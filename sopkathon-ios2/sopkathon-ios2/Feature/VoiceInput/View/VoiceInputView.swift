//
//  VoiceInputView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

import SwiftUI

struct VoiceInputView: View {
    @State private var viewModel: VoiceInputViewModel

    init(viewModel: VoiceInputViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: Metric.spacing) {
            ScrollView {
                Text(viewModel.transcript)
                    .typography(.h1Rg16)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            FullWidthButton(title: buttonTitle) {
                Task {
                    await viewModel.toggleRecording()
                }
            }
        }
        .padding(Metric.padding)
        .onDisappear {
            viewModel.stopRecording()
        }
    }

    private var buttonTitle: String {
        viewModel.isRecording ? Title.stop : Title.start
    }
}

private extension VoiceInputView {
    enum Metric {
        static let spacing: CGFloat = 12
        static let padding: CGFloat = 20
    }

    enum Title {
        static let start = "음성 입력 시작"
        static let stop = "음성 입력 종료"
    }
}
