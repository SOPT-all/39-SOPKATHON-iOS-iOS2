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

    private let teacherName: String

    init(teacherName: String, viewModel: VoiceInputViewModel) {
        self.teacherName = teacherName
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            titleView
                .padding(.top, Metric.topPadding)

            Color.clear
                .frame(height: Metric.graphicHeight)
                .overlay {
                    voiceGraphicView
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

            Text("\(teacherName)\(Title.listeningSuffix)")
                .font(Typography.header3.font)
        }
        .foregroundStyle(.textBlack)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Metric.titleHorizontalPadding)
    }

    private var voiceGraphicView: some View {
        ZStack {
            graphicImage(.graphicVoiceLine)

            ForEach(Array(Graphic.dots.enumerated()), id: \.offset) { index, dots in
                graphicImage(dots)
                    .opacity(isDotsVisible(at: index) ? 1 : 0)
            }
        }
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

    private func graphicImage(_ resource: ImageResource) -> some View {
        Image(resource)
            .resizable()
            .scaledToFill()
    }

    private func isDotsVisible(at index: Int) -> Bool {
        let threshold = Float(index + 1) / Float(Graphic.dots.count + 1)
        return viewModel.audioLevel >= threshold
    }
}

private extension VoiceInputView {
    enum Metric {
        static let topPadding: CGFloat = 29
        static let titleSpacing: CGFloat = 5
        static let titleHorizontalPadding: CGFloat = 45
        static let graphicTopPadding: CGFloat = 86
        static let graphicHeight: CGFloat = 109
        static let buttonTopPadding: CGFloat = 100
        static let buttonSpacing: CGFloat = 15
        static let buttonHorizontalPadding: CGFloat = 24
        static let bottomPadding: CGFloat = 15
    }

    enum Graphic {
        static let dots: [ImageResource] = [
            .graphicVoiceDots1,
            .graphicVoiceDots2,
            .graphicVoiceDots3,
            .graphicVoiceDots4,
            .graphicVoiceDots5
        ]
    }

    enum Title {
        static let status = "음성 인식중"
        static let listeningSuffix = "님의 기록을 듣고있어요."
        static let cancel = "중단"
        static let complete = "완료"
    }
}
