//
//  AskView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI
import SwiftData
import UIKit

struct AskView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \BabyProfile.createdAt) private var babyProfiles: [BabyProfile]
    @Query(sort: \QAHistory.createdAt, order: .reverse) private var qaHistory: [QAHistory]

    private let aiService: AIServiceProtocol = MockAIService()
    private let bottomAnchorId = "ask-bottom-anchor"

    private var baby: BabyProfile? {
        babyProfiles.first
    }

    private var messages: [AskMessage] {
        guard let babyId = baby?.id else { return [] }

        return qaHistory
            .filter { $0.babyId == babyId }
            .sorted { $0.createdAt < $1.createdAt }
            .flatMap { history in
                [
                    AskMessage(id: "\(history.id.uuidString)-q", text: history.question, isUser: true),
                    AskMessage(id: "\(history.id.uuidString)-a", text: history.answer, isUser: false)
                ]
            }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissKeyboard()
                    }

                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                            header

                            if messages.isEmpty {
                                emptyState
                            } else {
                                ForEach(messages) { message in
                                    ChatBubbleView(text: message.text, isUser: message.isUser)
                                        .id(message.id)
                                }
                            }

                            Color.clear
                                .frame(height: 1)
                                .id(bottomAnchorId)
                        }
                        .padding(AppTheme.Spacing.large)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .contentShape(Rectangle())
                    }
                    .scrollDismissesKeyboard(.immediately)
                    .onTapGesture {
                        dismissKeyboard()
                    }
                    .onAppear {
                        scrollToLatestMessage(with: proxy, animated: false)
                    }
                    .onChange(of: messages.count) {
                        scrollToLatestMessage(with: proxy)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                AskInputBar(
                    isEnabled: baby != nil,
                    onSend: sendQuestion,
                    onDismissKeyboard: dismissKeyboard
                )
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
            Text("问问")
                .font(AppTheme.Typography.title)
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Text("育儿参考不能替代医生诊断，严重症状请及时就医。")
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
        .padding(.bottom, AppTheme.Spacing.small)
    }

    private var emptyState: some View {
        EmptyStateCard(
            systemImage: "bubble.left.and.bubble.right",
            title: "可以这样问",
            message: "例如：宝宝晚上总醒怎么办？添加辅食后便便变了要注意什么？"
        )
    }

    private func sendQuestion(_ rawQuestion: String) {
        guard let baby else { return }

        let trimmedQuestion = rawQuestion.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuestion.isEmpty else { return }

        let answer = aiService.answer(question: trimmedQuestion, baby: baby)
        let history = QAHistory(babyId: baby.id, question: trimmedQuestion, answer: answer)
        modelContext.insert(history)
        dismissKeyboard()
    }

    private func dismissKeyboard() {
        UIApplication.shared.dismissKeyboard()
    }

    private func scrollToLatestMessage(with proxy: ScrollViewProxy, animated: Bool = true) {
        DispatchQueue.main.async {
            if animated {
                withAnimation(.easeOut(duration: 0.25)) {
                    proxy.scrollTo(bottomAnchorId, anchor: .bottom)
                }
            } else {
                proxy.scrollTo(bottomAnchorId, anchor: .bottom)
            }
        }
    }
}

private struct AskMessage: Identifiable {
    let id: String
    let text: String
    let isUser: Bool
}

private struct AskInputBar: View {
    let isEnabled: Bool
    let onSend: (String) -> Void
    let onDismissKeyboard: () -> Void

    @State private var question = ""
    @FocusState private var isFocused: Bool

    private var canSend: Bool {
        isEnabled && !question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        HStack(alignment: .center, spacing: AppTheme.Spacing.small) {
            TextField("输入育儿问题", text: $question)
                .focused($isFocused)
                .lineLimit(1)
                .textInputAutocapitalization(.never)
                .submitLabel(.send)
                .onSubmit(submitQuestion)
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .padding(.horizontal, AppTheme.Spacing.medium)
                .frame(height: 44)
                .background(AppTheme.Colors.field)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
                .overlay {
                    RoundedRectangle(cornerRadius: AppTheme.Radius.medium)
                        .stroke(
                            isFocused ? AppTheme.Colors.peach.opacity(0.5) : AppTheme.Colors.separator.opacity(0.45),
                            lineWidth: 1
                        )
                }

            Button {
                isFocused = false
                onDismissKeyboard()
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.peach)
                    .frame(width: 36, height: 44)
                    .background(AppTheme.Colors.peachSoft.opacity(0.26))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
            }
            .buttonStyle(.plain)
            .opacity(isFocused ? 1 : 0)
            .disabled(!isFocused)
            .accessibilityLabel("收起键盘")

            Button {
                submitQuestion()
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(canSend ? AppTheme.Colors.peach : AppTheme.Colors.disabled.opacity(0.55))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
            }
            .buttonStyle(.plain)
            .disabled(!canSend)
        }
        .padding(AppTheme.Spacing.medium)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(AppTheme.Colors.separator.opacity(0.45))
                .frame(height: 1)
        }
    }

    private func submitQuestion() {
        let currentQuestion = question
        guard canSend else { return }

        question = ""
        isFocused = false
        onSend(currentQuestion)
    }
}

#Preview {
    AskView()
        .modelContainer(for: [
            BabyProfile.self,
            GrowthRecord.self,
            FeedingRecord.self,
            SleepRecord.self,
            StoolRecord.self,
            QAHistory.self,
            MemoryCard.self
        ], inMemory: true)
}
