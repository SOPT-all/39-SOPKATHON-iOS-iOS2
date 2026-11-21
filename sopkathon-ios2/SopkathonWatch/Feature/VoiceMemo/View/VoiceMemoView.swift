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
        ScrollView {
            VStack(spacing: Metric.spacing) {
                TextFieldLink(prompt: Text(Title.prompt)) {
                    Label(Title.record, systemImage: Symbol.microphone)
                        .frame(maxWidth: .infinity)
                } onSubmit: { memo in
                    Task {
                        await viewModel.saveMemo(memo)
                    }
                }
                .buttonStyle(.borderedProminent)

                savedRecordListView
            }
        }
    }

    private var savedRecordListView: some View {
        VStack(alignment: .leading, spacing: Metric.recordSpacing) {
            ForEach(viewModel.savedRecords) { record in
                HStack {
                    Text(record.childName)
                        .font(.headline)

                    Spacer()

                    Text(record.category?.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.tint)
                }
            }
        }
    }
}

private extension VoiceMemoView {
    enum Metric {
        static let spacing: CGFloat = 12
        static let recordSpacing: CGFloat = 6
    }

    enum Title {
        static let record = "음성 메모"
        static let prompt = "기록할 내용을 말해 주세요"
    }

    enum Symbol {
        static let microphone = "mic.fill"
    }
}
