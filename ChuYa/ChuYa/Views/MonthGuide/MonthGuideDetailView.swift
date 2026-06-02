//
//  MonthGuideDetailView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI

struct MonthGuideDetailView: View {
    let stage: MonthGuideStage

    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                    header

                    GuideSectionCard(title: "发育特点", iconName: "figure.child", items: stage.development)
                    GuideSectionCard(title: "喂养重点", iconName: "drop", items: stage.feeding)
                    GuideSectionCard(title: "睡眠重点", iconName: "moon", items: stage.sleep)
                    GuideSectionCard(title: "亲子互动", iconName: "hands.sparkles", items: stage.interaction)
                    GuideSectionCard(title: "安全提醒", iconName: "shield.checkered", items: stage.safety)
                    GuideSectionCard(title: "常见问题", iconName: "questionmark.bubble", items: stage.commonQuestions)

                    disclaimer
                }
                .padding(AppTheme.Spacing.large)
            }
        }
        .navigationTitle(stage.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text(stage.title)
                .font(AppTheme.Typography.title)
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Text(stage.subtitle)
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.Spacing.large)
        .background(
            LinearGradient(
                colors: [AppTheme.Colors.card, AppTheme.Colors.sprout.opacity(0.18)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.large))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                .stroke(AppTheme.Colors.separator.opacity(0.5), lineWidth: 1)
        }
    }

    private var disclaimer: some View {
        Text(MonthGuideContentService.disclaimer)
            .font(AppTheme.Typography.caption)
            .foregroundStyle(AppTheme.Colors.textSecondary)
            .lineSpacing(3)
            .padding(AppTheme.Spacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.Colors.card)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
            .overlay {
                RoundedRectangle(cornerRadius: AppTheme.Radius.medium)
                    .stroke(AppTheme.Colors.separator.opacity(0.5), lineWidth: 1)
            }
    }
}

private struct GuideSectionCard: View {
    let title: String
    let iconName: String
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            HStack(spacing: AppTheme.Spacing.small) {
                Image(systemName: iconName)
                    .font(.headline)
                    .foregroundStyle(AppTheme.Colors.peach)
                    .frame(width: 36, height: 36)
                    .background(AppTheme.Colors.peachSoft.opacity(0.28))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.small))

                Text(title)
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: AppTheme.Spacing.small) {
                        Circle()
                            .fill(AppTheme.Colors.sprout)
                            .frame(width: 6, height: 6)
                            .padding(.top, 8)

                        Text(item)
                            .font(AppTheme.Typography.body)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                            .lineSpacing(3)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.Spacing.large)
        .background(AppTheme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.large))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                .stroke(AppTheme.Colors.separator.opacity(0.58), lineWidth: 1)
        }
    }
}

#Preview {
    NavigationStack {
        MonthGuideDetailView(stage: MonthGuideContentService.stages()[0])
    }
}

