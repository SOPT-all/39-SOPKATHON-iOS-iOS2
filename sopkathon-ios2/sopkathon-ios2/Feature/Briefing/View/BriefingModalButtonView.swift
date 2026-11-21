//
//  BriefingModalButtonView.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

import SwiftUI

struct BriefingModalButtonView: View {
    private let title: String
    private let appearance: ButtonAppearance
    private let action: () -> Void

    init(title: String, appearance: ButtonAppearance, action: @escaping () -> Void) {
        self.title = title
        self.appearance = appearance
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .typography(.subHeader2)
                .foregroundStyle(appearance == .secondary ? .textBlack : .baseWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background(appearance == .secondary ? .gray100 : .primary400)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .contentShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}
