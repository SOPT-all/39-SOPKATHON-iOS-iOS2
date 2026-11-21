//
//  SplashView.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/22/26.
//

import SwiftUI

import Lottie

struct SplashView: View {
    private let onFinish: () -> Void

    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }

    var body: some View {
        LottieView(animation: .named(Animation.name))
            .configure { $0.contentMode = .scaleAspectFill }
            .resizable()
            .playing(
                .fromFrame(
                    Timing.startFrame,
                    toFrame: Timing.endFrame,
                    loopMode: .playOnce
                )
            )
            .animationDidFinish { _ in
                Task {
                    try? await Task.sleep(for: Timing.holdDuration)
                    onFinish()
                }
            }
            .ignoresSafeArea()
    }
}

private enum Animation {
    static let name = "Splash"
}

private enum Timing {
    static let startFrame: CGFloat = 50
    static let endFrame: CGFloat = 171
    static let holdDuration: Duration = .seconds(1)
}
