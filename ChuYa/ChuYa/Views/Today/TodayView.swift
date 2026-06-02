//
//  TodayView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Query(sort: \BabyProfile.createdAt) private var babyProfiles: [BabyProfile]
    @State private var showingSettings = false

    private var baby: BabyProfile? {
        babyProfiles.first
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                            Text("今日")
                                .font(AppTheme.Typography.title)
                                .foregroundStyle(AppTheme.Colors.textPrimary)

                            Text("每天一点，陪宝宝长大。")
                                .font(AppTheme.Typography.body)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                        }

                        if let baby {
                            BabySummaryCard(baby: baby)

                            VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                                Text("今天可以这样照顾")
                                    .font(AppTheme.Typography.sectionTitle)
                                    .foregroundStyle(AppTheme.Colors.textPrimary)

                                ForEach(todayAdvice(for: baby)) { advice in
                                    AdviceCardView(advice: advice)
                                }
                            }
                        }
                    }
                    .padding(AppTheme.Spacing.large)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityLabel("设置")
                }
            }
            .navigationDestination(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }

    private func todayAdvice(for baby: BabyProfile) -> [BabyAdvice] {
        let ageInfo = BabyAgeCalculator.calculate(from: baby.birthday)
        return BabyAdviceService.todayAdvice(forMonthAge: ageInfo.monthsOld, feedingType: baby.feedingType)
    }
}

private struct BabySummaryCard: View {
    let baby: BabyProfile

    private var ageInfo: BabyAgeInfo {
        BabyAgeCalculator.calculate(from: baby.birthday)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                    Text(baby.name)
                        .font(AppTheme.Typography.title)
                        .foregroundStyle(AppTheme.Colors.textPrimary)

                    Text(ageInfo.displayText)
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }

                Spacer()

                Image(systemName: "heart.fill")
                    .foregroundStyle(AppTheme.Colors.peach)
                    .font(.title2)
            }

            HStack(spacing: AppTheme.Spacing.medium) {
                MetricPill(title: "出生", value: "\(ageInfo.daysOld) 天")
                MetricPill(title: "月龄", value: "\(ageInfo.monthsOld) 月")
                MetricPill(title: "喂养", value: baby.feedingType)
            }

            Text(Date(), format: Date.FormatStyle(date: .abbreviated, time: .omitted))
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.Spacing.large)
        .background(
            LinearGradient(
                colors: [AppTheme.Colors.card, AppTheme.Colors.peachSoft.opacity(0.28)],
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
}

private struct MetricPill: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: AppTheme.Spacing.xSmall) {
            Text(title)
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.textSecondary)

            Text(value)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.Spacing.small)
        .padding(.horizontal, AppTheme.Spacing.xSmall)
        .background(AppTheme.Colors.field.opacity(0.74))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
    }
}

#Preview {
    TodayView()
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
