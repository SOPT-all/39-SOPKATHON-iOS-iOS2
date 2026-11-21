//
//  ChildListView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

struct ChildListView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        ScrollView {
            VStack(spacing: Metric.spacing) {
                FullWidthButton(title: Title.register, appearance: .secondary) {
                    router.push(.childRegister)
                }

                FullWidthButton(title: Title.detail, appearance: .secondary) {
                    router.push(.childDetail(childID: Metric.sampleID))
                }
            }
            .padding(Metric.padding)
        }
    }
}

private extension ChildListView {
    enum Metric {
        static let spacing: CGFloat = 12
        static let padding: CGFloat = 20
        static let sampleID = 1
    }

    enum Title {
        static let register = "아이 등록"
        static let detail = "아이 수정"
    }
}
