//
//  BriefingMessageComposeView.swift
//  sopkathon-ios2
//
//  Created by Seoyoung Lee on 11/22/26.
//

import MessageUI
import SwiftUI

enum BriefingMessageComposeResult {
    case sent
    case cancelled
    case failed
}

struct BriefingMessageComposeView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool

    let recipient: String
    let content: String
    let onFinish: (BriefingMessageComposeResult) -> Void

    static var canSendText: Bool {
        MFMessageComposeViewController.canSendText()
    }

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let controller = MFMessageComposeViewController()
        controller.recipients = [recipient]
        controller.body = content
        controller.messageComposeDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(
        _ controller: MFMessageComposeViewController,
        context: Context
    ) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, onFinish: onFinish)
    }

    final class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        private var isPresented: Binding<Bool>
        private let onFinish: (BriefingMessageComposeResult) -> Void

        init(
            isPresented: Binding<Bool>,
            onFinish: @escaping (BriefingMessageComposeResult) -> Void
        ) {
            self.isPresented = isPresented
            self.onFinish = onFinish
        }

        func messageComposeViewController(
            _ controller: MFMessageComposeViewController,
            didFinishWith result: MessageComposeResult
        ) {
            isPresented.wrappedValue = false

            switch result {
            case .sent:
                onFinish(.sent)
            case .cancelled:
                onFinish(.cancelled)
            case .failed:
                onFinish(.failed)
            @unknown default:
                onFinish(.failed)
            }
        }
    }
}
