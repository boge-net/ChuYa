//
//  ChatBubbleView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI

struct ChatBubbleView: View {
    let text: String
    let isUser: Bool

    var body: some View {
        HStack(alignment: .bottom) {
            if isUser {
                Spacer(minLength: AppTheme.Spacing.xLarge)
            }

            Text(text)
                .font(AppTheme.Typography.body)
                .foregroundStyle(isUser ? .white : AppTheme.Colors.textPrimary)
                .lineSpacing(3)
                .padding(AppTheme.Spacing.medium)
                .background(isUser ? AppTheme.Colors.peach : AppTheme.Colors.card)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
                .overlay {
                    if !isUser {
                        RoundedRectangle(cornerRadius: AppTheme.Radius.medium)
                            .stroke(AppTheme.Colors.separator.opacity(0.5), lineWidth: 1)
                    }
                }

            if !isUser {
                Spacer(minLength: AppTheme.Spacing.xLarge)
            }
        }
    }
}

#Preview {
    VStack {
        ChatBubbleView(text: "宝宝今天不太想睡怎么办？", isUser: true)
        ChatBubbleView(text: "可能原因：宝宝的状态常常和月龄、作息、喂养节奏有关。", isUser: false)
    }
    .padding()
    .background(AppTheme.Colors.background)
}

