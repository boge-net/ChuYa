//
//  CardTemplateView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI

struct CardTemplate: Identifiable {
    let id: String
    let name: String
    let caption: String
    let accent: Color
    let symbolName: String

    static let fullMoon = CardTemplate(
        id: "fullMoon",
        name: "满月纪念卡",
        caption: "来到世界的第一个月",
        accent: AppTheme.Colors.peach,
        symbolName: "moon.stars"
    )

    static let hundredDays = CardTemplate(
        id: "hundredDays",
        name: "百天纪念卡",
        caption: "一百天的小小成长",
        accent: AppTheme.Colors.sprout,
        symbolName: "leaf"
    )

    static let birthday = CardTemplate(
        id: "birthday",
        name: "生日纪念卡",
        caption: "又长大一岁的温柔时刻",
        accent: AppTheme.Colors.lavender,
        symbolName: "gift"
    )

    static let all = [fullMoon, hundredDays, birthday]
}

struct CardTemplateView: View {
    let template: CardTemplate
    let isSelected: Bool

    var body: some View {
        HStack(spacing: AppTheme.Spacing.medium) {
            Image(systemName: template.symbolName)
                .font(.headline)
                .foregroundStyle(template.accent)
                .frame(width: 38, height: 38)
                .background(template.accent.opacity(0.16))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.small))

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                Text(template.name)
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                Text(template.caption)
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }

            Spacer()

            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isSelected ? template.accent : AppTheme.Colors.textSecondary.opacity(0.45))
        }
        .padding(AppTheme.Spacing.medium)
        .background(AppTheme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.Radius.medium)
                .stroke(isSelected ? template.accent.opacity(0.65) : AppTheme.Colors.separator.opacity(0.5), lineWidth: 1)
        }
    }
}
