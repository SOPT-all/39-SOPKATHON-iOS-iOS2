//
//  BriefingCompletedProfileView.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

struct BriefingCompletedProfileView: View {
    private let kid: BriefingKidModel
    private let size: ProfileCardSize
    private let isCompleted: Bool
    private let stampScale: CGFloat

    init(
        kid: BriefingKidModel,
        size: ProfileCardSize,
        isCompleted: Bool,
        stampScale: CGFloat = 1
    ) {
        self.kid = kid
        self.size = size
        self.isCompleted = isCompleted
        self.stampScale = stampScale
    }

    var body: some View {
        ProfileCard(childID: kid.id, name: kid.name, size: size)
            .overlay {
                Image("IconDoneCover")
                    .resizable()
                    .frame(width: size.length, height: size.length)
                    .scaleEffect(stampScale)
                    .opacity(isCompleted ? 1 : 0)
            }
    }
}
