//
//  BriefingView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/21/26.
//

import SwiftUI

struct BriefingView: View {
    @State private var viewModel: BriefingViewModel
    @State private var selectedDate = Date()

    init(viewModel: BriefingViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                dateSelectionView
                briefingListView
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("일일 브리핑")
        .task(id: selectedDate) {
            await viewModel.fetchDailyBriefings(for: selectedDate)
        }
    }

    private var dateSelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            DatePicker("브리핑 날짜", selection: $selectedDate, displayedComponents: .date)

            Button("목록 다시 조회") {
                Task { await viewModel.fetchDailyBriefings(for: selectedDate) }
            }
        }
    }

    @ViewBuilder
    private var briefingListView: some View {
        if let briefing = viewModel.briefing {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(briefing.date) · 기록 있는 아이 \(briefing.recordedKidCount)명")
                    .font(.headline)

                ForEach(briefing.kids) { kid in
                    kidCardView(kid)
                }
            }
        }
    }

    private func kidCardView(_ kid: BriefingKidModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(kid.name)
                .font(.headline)
            Text("만 \(kid.age)세 · 기록 \(kid.recordCount)건")
            Text("수유 \(kid.summary.feeding) · 수면 \(kid.summary.sleep) · 기저귀 \(kid.summary.diaper)")
            Text("보호자 \(kid.parent.name) · \(kid.parent.phone)")

            if let message = kid.briefing {
                Text(message.content)
            } else {
                Text("생성된 메시지가 없습니다.")
                    .foregroundStyle(.secondary)
            }

            Button {
                Task { await viewModel.createDailyBriefing(kidID: kid.id, for: selectedDate) }
            } label: {
                HStack {
                    if viewModel.generatingKidID == kid.id {
                        ProgressView()
                    }
                    Text(kid.briefing == nil ? "AI 메시지 생성" : "AI 메시지 다시 생성")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.generatingKidID != nil)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}
