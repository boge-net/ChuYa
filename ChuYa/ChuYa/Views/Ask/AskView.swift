//
//  AskView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI
import SwiftData

struct AskView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \BabyProfile.createdAt) private var babyProfiles: [BabyProfile]
    @Query(sort: \QAHistory.createdAt, order: .reverse) private var qaHistory: [QAHistory]

    @State private var question = ""
    private let aiService: AIServiceProtocol = MockAIService()

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

                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                            header

                            if messages.isEmpty {
                                emptyState
                            } else {
                                ForEach(messages) { message in
                                    ChatBubbleView(text: message.text, isUser: message.isUser)
                                }
                            }
                        }
                        .padding(AppTheme.Spacing.large)
                    }

                    inputBar
                }
            }
            .navigationBarTitleDisplayMode(.inline)
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

    private var inputBar: some View {
        HStack(alignment: .bottom, spacing: AppTheme.Spacing.small) {
            TextField("输入育儿问题", text: $question, axis: .vertical)
                .lineLimit(1...4)
                .chuyaField()

            Button {
                sendQuestion()
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
    }

    private var canSend: Bool {
        baby != nil && !question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func sendQuestion() {
        guard let baby else { return }

        let trimmedQuestion = question.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuestion.isEmpty else { return }

        let answer = aiService.answer(question: trimmedQuestion, baby: baby)
        let history = QAHistory(babyId: baby.id, question: trimmedQuestion, answer: answer)
        modelContext.insert(history)
        question = ""
    }
}

private struct AskMessage: Identifiable {
    let id: String
    let text: String
    let isUser: Bool
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
