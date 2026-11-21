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
                ForEach(Self.shortcuts) { shortcut in
                    FullWidthButton(title: shortcut.title, appearance: .secondary) {
                        router.push(shortcut.route)
                    }
                }
            }
            .padding(Metric.padding)
        }
    }
}

private extension HomeView {
    struct Shortcut: Identifiable {
        let title: String
        let route: Route

        var id: Route { route }
    }

    enum Metric {
        static let spacing: CGFloat = 12
        static let padding: CGFloat = 20
        static let sampleID = 1
    }

    static let shortcuts = [
        Shortcut(title: "아이 등록", route: .childRegister),
        Shortcut(title: "아이 상세/수정", route: .childDetail(childID: Metric.sampleID)),
        Shortcut(title: "기록 입력", route: .recordInput),
        Shortcut(title: "음성 입력", route: .voiceInput),
        Shortcut(title: "아이별 기록 목록", route: .recordList(childID: Metric.sampleID)),
        Shortcut(title: "기록 수정", route: .recordEdit(recordID: Metric.sampleID)),
        Shortcut(title: "일일 브리핑 작성", route: .briefing),
        Shortcut(title: "발송 대상 선택", route: .sendTarget),
        Shortcut(title: "발송 전 확인", route: .sendConfirm),
        Shortcut(title: "발송 결과", route: .sendResult),
        Shortcut(title: "발송 이력 상세", route: .sendHistory)
    ]
}
