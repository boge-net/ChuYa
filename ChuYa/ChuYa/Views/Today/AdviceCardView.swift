//
//  AdviceCardView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI

struct AdviceCardView: View {
    let advice: BabyAdvice

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            HStack(alignment: .top, spacing: AppTheme.Spacing.medium) {
                Image(systemName: advice.kind.iconName)
                    .font(.title3)
                    .foregroundStyle(AppTheme.Colors.peach)
                    .frame(width: 42, height: 42)
                    .background(iconBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                    Text(advice.title)
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundStyle(AppTheme.Colors.textPrimary)

                    Text(advice.body)
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                        .lineSpacing(3)
                }
            }

            Text(advice.tip)
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .padding(AppTheme.Spacing.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.Colors.background.opacity(0.72))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
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

    private var iconBackground: Color {
        switch advice.kind {
        case .feeding:
            return AppTheme.Colors.peachSoft.opacity(0.34)
        case .sleep:
            return AppTheme.Colors.lavender.opacity(0.22)
        case .interaction:
            return AppTheme.Colors.sprout.opacity(0.24)
        case .safety:
            return AppTheme.Colors.peach.opacity(0.16)
        }
    }
}

#Preview {
    AdviceCardView(
        advice: BabyAdvice(
            kind: .feeding,
            title: "今日喂养",
            body: "以按需喂养为主，留意吞咽、尿量和精神状态。",
            tip: "不要强迫宝宝喝完固定量，先看宝宝状态和生长趋势。"
        )
    )
    .padding()
    .background(AppTheme.Colors.background)
}
