//
//  VoiceMemoView.swift
//  SopkathonWatch
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

struct VoiceMemoView: View {
    @State private var viewModel: VoiceMemoViewModel

    init(viewModel: VoiceMemoViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            contentView
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text(headerTitle)
                            .font(.pretendard(.regular, size: FontSize.statusDetail))
                            .foregroundStyle(.white.opacity(Opacity.navigationText))
                            .fixedSize()
                    }
                }
                .containerBackground(for: .navigation) {
                    backgroundView
                }
        }
    }

    private var headerTitle: String {
        switch viewModel.phase {
        case .ready:
            return Title.navigation
        case .recording, .paused:
            return Title.recordingHeader
        case .sending:
            return Title.sendingHeader
        case .sent:
            return Title.sentHeader
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.phase {
        case .ready:
            readyView
        case .recording, .paused:
            recordingView
        case .sending:
            sendingView
        case .sent:
            sentView
        }
    }

    private var backgroundView: some View {
        LinearGradient(
            stops: [
                .init(color: .memoGradient100, location: Gradient.location100),
                .init(color: .memoGradient200, location: Gradient.location200),
                .init(color: .memoGradient300, location: Gradient.location300),
                .init(color: .memoGradient400, location: Gradient.location400)
            ],
            startPoint: .bottomTrailing,
            endPoint: .topLeading
        )
        .overlay {
            RoundedRectangle(cornerRadius: Metric.screenCornerRadius)
                .stroke(.white.opacity(Opacity.glow), lineWidth: Metric.glowWidth)
                .blur(radius: Metric.glowBlurRadius)
        }
        .ignoresSafeArea()
    }

    private var readyView: some View {
        VStack(spacing: Metric.readySpacing) {
            Text(Title.guide)
                .font(.pretendard(.semiBold, size: FontSize.guide))
                .foregroundStyle(.white.opacity(Opacity.secondaryText))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)

            Button {
                Task {
                    await viewModel.startRecording()
                }
            } label: {
                VStack(spacing: Metric.startButtonSpacing) {
                    Image(.iconVoice)
                        .frame(width: Metric.startIconSize, height: Metric.startIconSize)
                        .background(.white.opacity(Opacity.startIconBackground), in: Circle())

                    emphasizedText(Title.start)
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var recordingView: some View {
        VStack(spacing: Metric.recordingSpacing) {
            waveformView

            emphasizedText(viewModel.elapsedText)

            HStack(spacing: Metric.controlSpacing) {
                if viewModel.phase == .paused {
                    controlButtonView(
                        title: Title.resume,
                        image: Image(systemName: Symbol.resume)
                    ) {
                        viewModel.togglePause()
                    }
                } else {
                    controlButtonView(title: Title.pause, image: Image(.iconPause)) {
                        viewModel.togglePause()
                    }
                }

                controlButtonView(title: Title.finish, image: Image(.iconStop)) {
                    Task {
                        await viewModel.finishRecording()
                    }
                }
            }
        }
    }

    private var waveformView: some View {
        HStack(spacing: Metric.barSpacing) {
            ForEach(viewModel.levels.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: Metric.barCornerRadius)
                    .fill(.white)
                    .frame(
                        maxWidth: Metric.barWidth,
                        minHeight: barHeight(for: viewModel.levels[index]),
                        maxHeight: barHeight(for: viewModel.levels[index])
                    )
            }
        }
        .frame(height: Metric.barMaxHeight)
        .animation(.linear(duration: Metric.barAnimationDuration), value: viewModel.levels)
    }

    private var sendingView: some View {
        VStack(spacing: 0) {
            Image(.graphicLogo)

            Image(.iconTransferProgress)
                .padding(.top, Metric.progressTopPadding)

            statusTextView(title: Title.sending, detail: Title.wait)
                .padding(.top, Metric.sendingTextTopPadding)

            Spacer(minLength: 0)
        }
    }

    private var sentView: some View {
        VStack(spacing: 0) {
            Image(.iconCheck)
                .frame(width: Metric.startIconSize, height: Metric.startIconSize)
                .background(.white.opacity(Opacity.startIconBackground), in: Circle())

            statusTextView(title: Title.sent, detail: Title.sentDetail)
                .padding(.top, Metric.sentTextTopPadding)

            Button {
                viewModel.resetMemo()
            } label: {
                Text(Title.newMemo)
                    .font(.pretendard(.semiBold, size: FontSize.guide))
                    .foregroundStyle(.white)
                    .shadow(
                        color: .black.opacity(Opacity.textShadow),
                        radius: Metric.textShadowRadius,
                        y: Metric.textShadowOffset
                    )
                    .frame(maxWidth: Metric.newMemoMaxWidth)
                    .frame(height: Metric.newMemoHeight)
                    .background(.memoControl, in: Capsule())
            }
            .buttonStyle(.plain)
            .padding(.top, Metric.newMemoTopPadding)

            Spacer(minLength: 0)
        }
    }

    private func statusTextView(title: String, detail: String) -> some View {
        VStack(spacing: Metric.statusSpacing) {
            Text(title)
                .font(.pretendard(.bold, size: FontSize.statusTitle))

            Text(detail)
                .font(.pretendard(.medium, size: FontSize.control))
        }
        .foregroundStyle(.white.opacity(Opacity.secondaryText))
        .lineLimit(1)
        .minimumScaleFactor(Metric.textMinimumScale)
    }

    private func emphasizedText(_ text: String) -> some View {
        Text(text)
            .font(.pretendard(.bold, size: FontSize.emphasis))
            .foregroundStyle(.white)
            .shadow(
                color: .black.opacity(Opacity.textShadow),
                radius: Metric.textShadowRadius,
                y: Metric.textShadowOffset
            )
    }

    private func controlButtonView(
        title: String,
        image: Image,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: Metric.controlLabelSpacing) {
                image
                    .foregroundStyle(.white)
                    .frame(width: Metric.controlSize, height: Metric.controlSize)
                    .background(.memoControl, in: Circle())

                Text(title)
                    .font(.pretendard(.medium, size: FontSize.control))
                    .foregroundStyle(.white.opacity(Opacity.secondaryText))
            }
        }
        .buttonStyle(.plain)
    }

    private func barHeight(for level: Double) -> CGFloat {
        Metric.barMinHeight + (Metric.barMaxHeight - Metric.barMinHeight) * level
    }
}

private extension VoiceMemoView {
    enum Metric {
        static let readySpacing: CGFloat = 8
        static let startButtonSpacing: CGFloat = 12
        static let startIconSize: CGFloat = 67
        static let recordingSpacing: CGFloat = 6
        static let controlSpacing: CGFloat = 35
        static let controlSize: CGFloat = 45
        static let controlLabelSpacing: CGFloat = 5
        static let barWidth: CGFloat = 3
        static let barSpacing: CGFloat = 4
        static let barCornerRadius: CGFloat = 2
        static let barMinHeight: CGFloat = 7
        static let barMaxHeight: CGFloat = 63
        static let barAnimationDuration: Double = 0.08
        static let statusSpacing: CGFloat = 4
        static let progressTopPadding: CGFloat = 7
        static let sendingTextTopPadding: CGFloat = 18
        static let sentTextTopPadding: CGFloat = 13
        static let newMemoTopPadding: CGFloat = 22
        static let newMemoHeight: CGFloat = 36
        static let newMemoMaxWidth: CGFloat = 167
        static let textMinimumScale: CGFloat = 0.8
        static let screenCornerRadius: CGFloat = 44
        static let glowWidth: CGFloat = 6
        static let glowBlurRadius: CGFloat = 5
        static let textShadowRadius: CGFloat = 4
        static let textShadowOffset: CGFloat = 1
    }

    enum FontSize {
        static let guide: CGFloat = 14
        static let emphasis: CGFloat = 24
        static let control: CGFloat = 13
        static let statusTitle: CGFloat = 16
        static let statusDetail: CGFloat = 12
    }

    enum Opacity {
        static let secondaryText: Double = 0.86
        static let navigationText: Double = 0.93
        static let startIconBackground: Double = 0.42
        static let textShadow: Double = 0.29
        static let glow: Double = 0.8
    }

    enum Gradient {
        static let location100: CGFloat = 0.015
        static let location200: CGFloat = 0.375
        static let location300: CGFloat = 0.745
        static let location400: CGFloat = 1
    }

    enum Title {
        static let navigation = "돌봄 메모"
        static let recordingHeader = "메모중"
        static let sendingHeader = "전송중"
        static let sentHeader = "전송 완료"
        static let guide = "아이 이름과 함께\n돌봄 내용을 말해 주세요"
        static let start = "녹음 시작"
        static let pause = "일시 정지"
        static let resume = "계속"
        static let finish = "종료"
        static let sending = "녹음을 보내고 있어요!"
        static let wait = "잠시만 기다려 주세요"
        static let sent = "앱에서 확인해 주세요!"
        static let sentDetail = "기록은 확인 후 저장돼요"
        static let newMemo = "새 메모"
    }

    enum Symbol {
        static let resume = "play.fill"
    }
}
