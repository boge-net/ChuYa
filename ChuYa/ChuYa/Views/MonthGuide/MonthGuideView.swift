//
//  MonthGuideView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI

struct MonthGuideView: View {
    private let stages = MonthGuideContentService.stages()

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                        header

                        LazyVStack(spacing: AppTheme.Spacing.medium) {
                            ForEach(stages) { stage in
                                NavigationLink {
                                    MonthGuideDetailView(stage: stage)
                                } label: {
                                    MonthGuideStageCard(stage: stage)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(AppTheme.Spacing.large)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
            Text("月龄")
                .font(AppTheme.Typography.title)
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Text("按阶段查看宝宝成长、喂养、睡眠和安全重点。")
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
    }
}

#Preview {
    MonthGuideView()
}

private struct MonthGuideStageCard: View {
    let stage: MonthGuideStage

    var body: some View {
        HStack(alignment: .center, spacing: AppTheme.Spacing.medium) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                Text(stage.title)
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                Text(stage.subtitle)
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.Colors.textSecondary)

                HStack(spacing: AppTheme.Spacing.xSmall) {
                    TagText("发育")
                    TagText("喂养")
                    TagText("安全")
                }
                .padding(.top, AppTheme.Spacing.xSmall)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
        .padding(AppTheme.Spacing.large)
        .background(AppTheme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.large))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                .stroke(AppTheme.Colors.separator.opacity(0.58), lineWidth: 1)
        }
    }
}

private struct TagText: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(AppTheme.Typography.caption)
            .foregroundStyle(AppTheme.Colors.peach)
            .padding(.horizontal, AppTheme.Spacing.small)
            .padding(.vertical, AppTheme.Spacing.xSmall)
            .background(AppTheme.Colors.peachSoft.opacity(0.28))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.small))
    }
}

