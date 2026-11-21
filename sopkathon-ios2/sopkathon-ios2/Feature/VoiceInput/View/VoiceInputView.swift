//
//  VoiceInputView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

import SwiftUI

struct VoiceInputView: View {
    @Environment(AppRouter.self) private var router

    @State private var viewModel: VoiceInputViewModel

    init(viewModel: VoiceInputViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            titleView
                .padding(.top, Metric.topPadding)

            Color.clear
                .frame(height: Metric.graphicHeight)
                .overlay {
                    Image(.graphicVoice)
                        .resizable()
                        .scaledToFill()
                }
                .padding(.top, Metric.graphicTopPadding)

            buttonRowView
                .padding(.top, Metric.buttonTopPadding)
                .padding(.bottom, Metric.bottomPadding)
        }
        .task {
            await viewModel.startRecording()
        }
        .onDisappear {
            viewModel.cancelRecording()
        }
    }

    private var titleView: some View {
        VStack(alignment: .leading, spacing: Metric.titleSpacing) {
            Text(Title.status)
                .font(Typography.caption1.font)

            Text(Title.listening)
                .font(Typography.header3.font)
        }
        .foregroundStyle(.textBlack)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Metric.titleHorizontalPadding)
    }

    private var buttonRowView: some View {
        HStack(spacing: Metric.buttonSpacing) {
            FullWidthButton(title: Title.cancel, appearance: .secondary) {
                router.dismissSheet()
            }

            FullWidthButton(title: Title.complete) {
                Task {
                    await viewModel.completeRecording()
                }
                router.dismissSheet()
            }
        }
        .padding(.horizontal, Metric.buttonHorizontalPadding)
    }
}

private extension VoiceInputView {
    enum Metric {
        static let topPadding: CGFloat = 29
        static let titleSpacing: CGFloat = 5
        static let titleHorizontalPadding: CGFloat = 45
        static let graphicTopPadding: CGFloat = 86
        static let graphicHeight: CGFloat = 69
        static let buttonTopPadding: CGFloat = 100
        static let buttonSpacing: CGFloat = 15
        static let buttonHorizontalPadding: CGFloat = 24
        static let bottomPadding: CGFloat = 15
    }

    enum Title {
        static let status = "음성 인식중"
        static let listening = "선생님의 기록을 듣고있어요."
        static let cancel = "중단"
        static let complete = "완료"
    }
}
