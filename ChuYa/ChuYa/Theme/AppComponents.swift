//
//  AppComponents.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI

struct AppScreen<Content: View>: View {
    private let title: String
    private let subtitle: String
    private let content: Content

    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                            Text(title)
                                .font(AppTheme.Typography.title)
                                .foregroundStyle(AppTheme.Colors.textPrimary)

                            Text(subtitle)
                                .font(AppTheme.Typography.body)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                        }

                        content
                    }
                    .padding(AppTheme.Spacing.large)
                }
            }
        }
    }
}

struct PlaceholderCard: View {
    let systemImage: String
    let title: String
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(AppTheme.Colors.peach)
                .frame(width: 44, height: 44)
                .background(AppTheme.Colors.peachSoft.opacity(0.35))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                Text(title)
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                Text(message)
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                    .lineSpacing(3)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .chuyaCard()
    }
}

struct EmptyStateCard: View {
    let systemImage: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(AppTheme.Colors.sprout)
                .frame(width: 46, height: 46)
                .background(AppTheme.Colors.sprout.opacity(0.16))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))

            VStack(spacing: AppTheme.Spacing.xSmall) {
                Text(title)
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
        }
        .frame(maxWidth: .infinity)
        .chuyaCard()
    }
}

struct PrimaryActionButtonStyle: ButtonStyle {
    let isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.headline, design: .rounded, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.medium)
            .background(isEnabled ? AppTheme.Colors.peach : AppTheme.Colors.disabled.opacity(0.55))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
            .opacity(configuration.isPressed ? 0.78 : 1)
    }
}

extension View {
    func chuyaCard(cornerRadius: CGFloat = AppTheme.Radius.large) -> some View {
        self
            .padding(AppTheme.Spacing.large)
            .background(AppTheme.Colors.card)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(AppTheme.Colors.separator.opacity(0.58), lineWidth: 1)
            }
    }

    func chuyaField() -> some View {
        self
            .font(AppTheme.Typography.body)
            .padding(AppTheme.Spacing.medium)
            .background(AppTheme.Colors.field)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
            .foregroundStyle(AppTheme.Colors.textPrimary)
    }
}
