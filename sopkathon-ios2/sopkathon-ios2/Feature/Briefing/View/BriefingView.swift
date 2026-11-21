//
//  BriefingView.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/21/26.
//

import SwiftUI

struct BriefingView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel: BriefingViewModel
    @State private var selectedKidID: Int?
    @State private var lastSentKidID: Int?
    @State private var instruction = ""
    @State private var isConfirming = false
    @State private var isMessagePresented = false
    @State private var isFirstTextVisible = true
    @State private var isSecondTextVisible = false
    @State private var isStampVisible = false
    @State private var phase: BriefingPhase = .compose

    init(viewModel: BriefingViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            switch phase {
            case .compose: composeView
            case .sent: sentView
            case .allDone: allDoneView
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .background(.baseWhite)
        .task {
            await viewModel.fetchDailyBriefings()
            selectInitialKid()
        }
        .sheet(isPresented: $isMessagePresented) {
            if let selectedKid,
               let parent = selectedKid.parent,
               let message = selectedKid.briefing {
                BriefingMessageComposeView(
                    isPresented: $isMessagePresented,
                    recipient: parent.phone,
                    content: message.content,
                    onFinish: handleMessageResult
                )
            }
        }
        .overlay {
            if isConfirming { confirmationView }
        }
    }

    private var composeView: some View {
        VStack(spacing: 0) {
            headerView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    introductionView
                    profileSelectionView
                    Rectangle().fill(.gray50).frame(height: 2)
                    childDetailsView
                        .background(alignment: .top) {
                            LinearGradient(
                                stops: [
                                    .init(color: .baseWhite.opacity(0), location: 0),
                                    .init(color: .baseWhite.opacity(0), location: 0.2),
                                    .init(color: .baseGradient, location: 1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .opacity(0.8)
                            .frame(height: Metric.gradientHeight)
                            .offset(y: -Metric.gradientTopOverlap)
                        }
                }
            }
            .scrollDismissesKeyboard(.interactively)

            BriefingBottomButtonView(title: "문자 발송하기", isEnabled: canComposeMessage) {
                isConfirming = true
            }
        }
        .task(id: selectedKidID) {
            guard let selectedKidID else { return }
            await viewModel.prepareDailyBriefing(kidID: selectedKidID)
        }
    }

    private var headerView: some View {
        NavigationHeader(title: "브리핑 작성", style: .bar) {
            router.selectTab(.home)
        }
    }

    private var introductionView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(viewModel.briefingDateText)
                .typography(.caption1)
            Text("돌봄 기록을 마무리해요")
                .typography(.header2)
            (Text("기록한 아이 ").font(Typography.caption1.font)
                + Text("\(viewModel.briefing?.recordedKidNames.count ?? 0)명")
                    .font(Typography.body2.font))
                .skeleton(!viewModel.hasFetched)
        }
        .foregroundStyle(.textBlack)
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 18)
    }

    private var profileSelectionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if viewModel.hasFetched {
                    ForEach(viewModel.briefing?.kids ?? []) { kid in
                        Button {
                            selectedKidID = kid.id
                            instruction = ""
                        } label: {
                            BriefingCompletedProfileView(
                                kid: kid,
                                size: .medium,
                                isCompleted: viewModel.isSent(kidID: kid.id)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    ForEach(0..<Metric.skeletonProfileCount, id: \.self) { _ in
                        SkeletonBox(
                            width: ProfileCardSize.medium.length,
                            height: ProfileCardSize.medium.length,
                            cornerRadius: ProfileCardSize.medium.cornerRadius
                        )
                    }
                }
            }
            .padding(.horizontal, 21)
        }
        .padding(.bottom, 20)
    }

    @ViewBuilder
    private var childDetailsView: some View {
        if let kid = selectedKid {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 20) {
                    BriefingCompletedProfileView(
                        kid: kid,
                        size: .large,
                        isCompleted: viewModel.isSent(kidID: kid.id)
                    )

                    VStack(alignment: .leading, spacing: 3) {
                        (Text(kid.name).font(Typography.body4.font)
                            + Text(" 만\(kid.age)세").font(Typography.body5.font))
                        Text("오늘 기록 \(kid.recordCount)건 완료")
                            .typography(.body5)
                    }
                    .foregroundStyle(.textBlack)
                }
                .padding(.bottom, 29)

                summaryView(kid)
                    .padding(.bottom, 38)

                refinementView(kid)
            }
            .padding(.horizontal, 24)
            .padding(.top, 25)
            .padding(.bottom, 30)
            .frame(maxWidth: .infinity, alignment: .leading)
        } else if !viewModel.hasFetched {
            childDetailsSkeletonView
        }
    }

    private var childDetailsSkeletonView: some View {
        VStack(alignment: .leading, spacing: Metric.skeletonSectionSpacing) {
            HStack(spacing: 20) {
                SkeletonBox(
                    width: ProfileCardSize.large.length,
                    height: ProfileCardSize.large.length,
                    cornerRadius: ProfileCardSize.large.cornerRadius
                )

                VStack(alignment: .leading, spacing: Metric.skeletonLineSpacing) {
                    SkeletonBox(width: Metric.skeletonNameWidth, height: Metric.skeletonLineHeight)

                    SkeletonBox(width: Metric.skeletonCountWidth, height: Metric.skeletonLineHeight)
                }
            }

            VStack(alignment: .leading, spacing: Metric.skeletonLineSpacing) {
                ForEach(0..<Metric.skeletonSummaryCount, id: \.self) { _ in
                    SkeletonBox(height: Metric.skeletonSummaryHeight)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 25)
        .padding(.bottom, 30)
    }

    private func summaryView(_ kid: BriefingKidModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(kid.summaryRows.indices, id: \.self) { index in
                HStack(spacing: 10) {
                    ForEach(kid.summaryRows[index], id: \.category) { item in
                        CategorySummaryChip(category: item.category, summary: "\(item.count)회")
                    }
                }
            }
        }
    }

    private func refinementView(_ kid: BriefingKidModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("내용 다듬기")
                .typography(.subHeader1)
                .foregroundStyle(.textBlack)

            if let message = kid.briefing {
                VStack(alignment: .leading, spacing: 20) {
                    Text(message.content)
                        .typography(.body5)
                        .foregroundStyle(.textBlack)

                    HStack(spacing: 8) {
                        TextField(
                            "수정하고 싶은 방향을 알려주세요",
                            text: $instruction
                        )
                            .font(Typography.body5.font)
                            .submitLabel(.done)

                        Button("수정") {
                            Task {
                                await viewModel.updateDailyBriefing(
                                    briefingID: message.id,
                                    instruction: instruction
                                )
                                if selectedKid?.briefing?.content != message.content {
                                    instruction = ""
                                }
                            }
                        }
                        .typography(.body4)
                        .foregroundStyle(.baseWhite)
                        .padding(.horizontal, 12)
                        .frame(height: 31)
                        .background(.primary400)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .disabled(
                            instruction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        )
                    }
                    .padding(7)
                    .background(.gray50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.baseWhite)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay {
                    RoundedRectangle(cornerRadius: 15).stroke(.gray300, lineWidth: 1)
                }
            }
        }
    }

    private var confirmationView: some View {
        ZStack {
            Color.baseBlack.opacity(0.6).ignoresSafeArea()

            VStack(spacing: 0) {
                if let selectedKid {
                    ProfileCard(childID: selectedKid.id, name: selectedKid.name, size: .extraLarge)
                        .padding(.top, 50)
                }

                Text("문자를 전송 할까요?")
                    .typography(.subHeader1)
                    .foregroundStyle(.textBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 27)

                Text("메시지는 저장된 정보의 연락처로 전송돼요")
                    .typography(.caption1)
                    .foregroundStyle(.disabled150)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)

                HStack(spacing: 15) {
                    BriefingModalButtonView(title: "취소", appearance: .secondary) {
                        isConfirming = false
                    }
                    BriefingModalButtonView(title: "전송", appearance: .primary) {
                        isConfirming = false
                        if viewModel.isMockPreview {
                            handleMessageResult(.sent)
                        } else {
                            isMessagePresented = true
                        }
                    }
                }
                .padding(.top, 21)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 15)
            .frame(width: 331)
            .background(.baseWhite)
            .clipShape(RoundedRectangle(cornerRadius: 30))
        }
    }

    private var sentView: some View {
        VStack {
            Spacer()

            if let lastSentKid = viewModel.briefing?.kids.first(where: { $0.id == lastSentKidID }) {
                HStack(spacing: 9) {
                    BriefingCompletedProfileView(
                        kid: lastSentKid,
                        size: .extraLarge,
                        isCompleted: isStampVisible,
                        stampScale: isStampVisible ? 1 : 0.1
                    )

                    ForEach(remainingKids.prefix(3)) { kid in
                        ProfileCard(childID: kid.id, name: kid.name, size: .medium)
                    }
                }

                VStack(spacing: 4) {
                    if isFirstTextVisible {
                        Text("\(lastSentKid.name.dropFirst())이의 부모님에게")
                            .typography(.header2)
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }

                    VStack(spacing: 3) {
                        Text("전송을 완료했어요")
                            .typography(.header2)
                            .foregroundStyle(.primary400)
                        Text("이어서 브리핑을 작성해볼까요?")
                            .typography(.header3)
                    }
                    .offset(y: isSecondTextVisible ? 0 : 50)
                    .opacity(isSecondTextVisible ? 1 : 0)
                }
                .foregroundStyle(.textBlack)
                .padding(.top, 48)
            }

            Spacer()

            BriefingBottomButtonView(title: "이어서 작성", isEnabled: isSecondTextVisible) {
                selectedKidID = remainingKids.first?.id
                instruction = ""
                phase = .compose
            }
        }
    }

    private var allDoneView: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()

                carouselView
                    .frame(height: 85)

                Text("오늘의 브리핑 완료!")
                    .typography(.header2)
                    .foregroundStyle(.primary400)
                    .padding(.top, 48)
                Text("아이들과 함께하느라 수고 많으셨어요")
                    .typography(.header3)
                    .foregroundStyle(.textBlack)
                    .padding(.top, 4)

                Spacer()

                BriefingBottomButtonView(title: "홈 으로", isEnabled: true) {
                    router.selectTab(.home)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    private var carouselView: some View {
        GeometryReader { geometry in
            TimelineView(.periodic(from: .now, by: 1.0 / 30.0)) { timeline in
                let kids = viewModel.briefing?.kids ?? []
                let cycleWidth = CGFloat(kids.count) * 99
                let elapsed = timeline.date.timeIntervalSinceReferenceDate
                let offset = cycleWidth > 0
                    ? CGFloat(elapsed * 30).truncatingRemainder(dividingBy: cycleWidth)
                    : 0

                HStack(spacing: 14) {
                    ForEach(0..<7, id: \.self) { repetition in
                        ForEach(kids) { kid in
                            BriefingCompletedProfileView(
                                kid: kid,
                                size: .extraLarge,
                                isCompleted: viewModel.isSent(kidID: kid.id)
                            )
                                .scaleEffect(85.0 / 90.0)
                                .frame(width: 85, height: 85)
                                .id("\(repetition)-\(kid.id)")
                        }
                    }
                }
                .offset(x: -cycleWidth - offset)
                .frame(width: geometry.size.width, alignment: .leading)
                .clipped()
            }
        }
    }

    private var selectedKid: BriefingKidModel? {
        viewModel.briefing?.kids.first(where: { $0.id == selectedKidID })
    }

    private var remainingKids: [BriefingKidModel] {
        viewModel.briefing?.kids.filter { !viewModel.isSent(kidID: $0.id) } ?? []
    }

    private var canComposeMessage: Bool {
        guard let selectedKid else { return false }
        return selectedKid.briefing != nil
            && selectedKid.parent != nil
            && !viewModel.isSent(kidID: selectedKid.id)
            && (viewModel.isMockPreview || BriefingMessageComposeView.canSendText)
    }

    private func selectInitialKid() {
        guard let kids = viewModel.briefing?.kids, !kids.isEmpty else { return }
        selectedKidID = remainingKids.first?.id ?? kids.first?.id
        if remainingKids.isEmpty {
            phase = .allDone
        }
    }

    private func handleMessageResult(_ result: BriefingMessageComposeResult) {
        guard case .sent = result, let selectedKidID else { return }
        viewModel.markSent(kidID: selectedKidID)
        lastSentKidID = selectedKidID

        if remainingKids.isEmpty {
            phase = .allDone
            return
        }

        isFirstTextVisible = true
        isSecondTextVisible = false
        isStampVisible = false
        phase = .sent

        Task {
            try? await Task.sleep(for: .milliseconds(350))
            withAnimation(.easeInOut(duration: 0.35)) {
                isFirstTextVisible = false
            }
            try? await Task.sleep(for: .milliseconds(300))
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                isSecondTextVisible = true
                isStampVisible = true
            }
        }
    }
}

private enum BriefingPhase {
    case compose
    case sent
    case allDone
}

private enum Metric {
    static let gradientHeight: CGFloat = 722
    static let gradientTopOverlap: CGFloat = 31
    static let skeletonProfileCount = 4
    static let skeletonSectionSpacing: CGFloat = 29
    static let skeletonLineSpacing: CGFloat = 10
    static let skeletonLineHeight: CGFloat = 16
    static let skeletonNameWidth: CGFloat = 96
    static let skeletonCountWidth: CGFloat = 132
    static let skeletonSummaryCount = 3
    static let skeletonSummaryHeight: CGFloat = 36
}
