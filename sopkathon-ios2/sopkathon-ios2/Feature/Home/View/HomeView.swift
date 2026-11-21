//
//  HomeView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        ScrollView {
            VStack(spacing: Metric.spacing) {
                FullWidthButton(title: Title.textMemo, appearance: .secondary) {
                    router.push(.recordInput)
                }

                FullWidthButton(title: Title.voiceMemo, appearance: .secondary) {
                    router.presentSheet(.voiceInput)
                }

                FullWidthButton(title: Title.briefing, appearance: .secondary) {
                    router.selectTab(.briefing)
                }
            }
            .padding(Metric.padding)
        }
    }
}

private extension HomeView {
    enum Metric {
        static let spacing: CGFloat = 12
        static let padding: CGFloat = 20
    }

    enum Title {
        static let textMemo = "텍스트 메모"
        static let voiceMemo = "음성 메모"
        static let briefing = "오늘 하루 브리핑 작성하기"
    }
}
