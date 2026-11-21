//
//  SkeletonBox.swift
//  sopkathon-ios2
//
//  Created by h2e on 11/22/26.
//

import SwiftUI

struct SkeletonBox: View {
    @State private var isAnimating = false

    private let width: CGFloat?
    private let height: CGFloat?
    private let cornerRadius: CGFloat

    init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = SkeletonMetric.cornerRadius
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(.gray100)
            .overlay {
                GeometryReader { proxy in
                    LinearGradient(
                        colors: [.clear, .baseWhite.opacity(SkeletonMetric.shineOpacity), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .offset(x: isAnimating ? proxy.size.width : -proxy.size.width)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .frame(width: width, height: height)
            .onAppear {
                withAnimation(
                    .linear(duration: SkeletonMetric.duration).repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

extension View {
    func skeleton(
        _ isActive: Bool,
        cornerRadius: CGFloat = SkeletonMetric.cornerRadius
    ) -> some View {
        opacity(isActive ? 0 : 1)
            .overlay {
                if isActive {
                    SkeletonBox(cornerRadius: cornerRadius)
                }
            }
            .allowsHitTesting(!isActive)
    }
}

enum SkeletonMetric {
    static let cornerRadius: CGFloat = 8
    static let shineOpacity: Double = 0.7
    static let duration: Double = 1.2
}
