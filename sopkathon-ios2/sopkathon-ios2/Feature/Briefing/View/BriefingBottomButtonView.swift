//
//  BriefingBottomButtonView.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

import SwiftUI

struct BriefingBottomButtonView: View {
    private let title: String
    private let isEnabled: Bool
    private let action: () -> Void

    init(title: String, isEnabled: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        FullWidthButton(
            title: title,
            textStyle: .subHeader1,
            isEnabled: isEnabled,
            action: action
        )
            .padding(.horizontal, 24)
            .padding(.top, 9)
            .padding(.bottom, 15)
            .background(.baseWhite)
    }
}
