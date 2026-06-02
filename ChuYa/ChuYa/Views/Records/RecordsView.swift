//
//  RecordsView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI
import SwiftData

struct RecordsView: View {
    @Query(sort: \BabyProfile.createdAt) private var babyProfiles: [BabyProfile]
    @Query(sort: \GrowthRecord.date, order: .reverse) private var growthRecords: [GrowthRecord]
    @Query(sort: \FeedingRecord.date, order: .reverse) private var feedingRecords: [FeedingRecord]
    @Query(sort: \SleepRecord.date, order: .reverse) private var sleepRecords: [SleepRecord]
    @Query(sort: \StoolRecord.date, order: .reverse) private var stoolRecords: [StoolRecord]

    @State private var isShowingAddRecord = false

    private var baby: BabyProfile? {
        babyProfiles.first
    }

    private var recentItems: [RecentRecordItem] {
        guard let babyId = baby?.id else { return [] }

        let growthItems = growthRecords
            .filter { $0.babyId == babyId }
            .map { RecentRecordItem(record: $0) }

        let feedingItems = feedingRecords
            .filter { $0.babyId == babyId }
            .map { RecentRecordItem(record: $0) }

        let sleepItems = sleepRecords
            .filter { $0.babyId == babyId }
            .map { RecentRecordItem(record: $0) }

        let stoolItems = stoolRecords
            .filter { $0.babyId == babyId }
            .map { RecentRecordItem(record: $0) }

        return (growthItems + feedingItems + sleepItems + stoolItems)
            .sorted { $0.date > $1.date }
            .prefix(12)
            .map { $0 }
    }

    var body: some View {
        AppScreen(title: "记录", subtitle: "把宝宝的变化轻轻记下来。") {
            quickAddCard

            if let baby {
                GrowthChartView(
                    records: growthRecords
                        .filter { $0.babyId == baby.id }
                        .sorted { $0.date < $1.date }
                )

                recentRecordsSection
            } else {
                EmptyStateCard(
                    systemImage: "person.crop.circle.badge.plus",
                    title: "还没有宝宝档案",
                    message: "先创建宝宝档案后，就可以开始记录成长变化。"
                )
            }
        }
        .sheet(isPresented: $isShowingAddRecord) {
            if let baby {
                AddRecordView(baby: baby)
            }
        }
    }

    private var quickAddCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                    Text("快捷添加")
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundStyle(AppTheme.Colors.textPrimary)

                    Text("记录身高体重、喂养、睡眠和便便")
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }

                Spacer()

                Button {
                    isShowingAddRecord = true
                } label: {
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 42, height: 42)
                        .background(AppTheme.Colors.peach)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
                }
                .buttonStyle(.plain)
                .disabled(baby == nil)
            }
        }
        .padding(AppTheme.Spacing.large)
        .background(AppTheme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.large))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                .stroke(AppTheme.Colors.separator.opacity(0.58), lineWidth: 1)
        }
    }

    private var recentRecordsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("最近记录")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundStyle(AppTheme.Colors.textPrimary)

            if recentItems.isEmpty {
                EmptyStateCard(
                    systemImage: "tray",
                    title: "还没有记录",
                    message: "今天可以先记一条身高体重、喂养、睡眠或便便。慢慢积累，就能看到宝宝的变化。"
                )
            } else {
                VStack(spacing: AppTheme.Spacing.small) {
                    ForEach(recentItems) { item in
                        RecentRecordRow(item: item)
                    }
                }
            }
        }
    }
}

#Preview {
    RecordsView()
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

private struct RecentRecordItem: Identifiable {
    let id: UUID
    let date: Date
    let iconName: String
    let title: String
    let detail: String

    init(record: GrowthRecord) {
        id = record.id
        date = record.date
        iconName = "chart.xyaxis.line"
        title = "身高体重"

        let heightText = record.height.map { "身高 \(Self.formatNumber($0)) cm" }
        let weightText = record.weight.map { "体重 \(Self.formatNumber($0)) kg" }
        detail = [heightText, weightText, record.note]
            .compactMap { $0 }
            .joined(separator: " · ")
    }

    init(record: FeedingRecord) {
        id = record.id
        date = record.date
        iconName = "drop"
        title = "喂养"

        let amountText = record.amount.map { "\(Self.formatNumber($0)) ml" }
        detail = [record.type, amountText, record.foodName, record.note]
            .compactMap { $0 }
            .joined(separator: " · ")
    }

    init(record: SleepRecord) {
        id = record.id
        date = record.date
        iconName = "moon"
        title = "睡眠"

        let duration = record.endTime.timeIntervalSince(record.startTime)
        let hours = max(0, duration / 3600)
        detail = "约 \(Self.formatNumber(hours)) 小时" + (record.note.map { " · \($0)" } ?? "")
    }

    init(record: StoolRecord) {
        id = record.id
        date = record.date
        iconName = "sparkles"
        title = "便便"
        detail = [record.color, record.shape, record.note]
            .compactMap { $0 }
            .joined(separator: " · ")
    }

    private static func formatNumber(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...1)))
    }
}

private struct RecentRecordRow: View {
    let item: RecentRecordItem

    var body: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.medium) {
            Image(systemName: item.iconName)
                .font(.headline)
                .foregroundStyle(AppTheme.Colors.peach)
                .frame(width: 38, height: 38)
                .background(AppTheme.Colors.peachSoft.opacity(0.32))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                HStack {
                    Text(item.title)
                        .font(.system(.body, design: .rounded, weight: .semibold))
                        .foregroundStyle(AppTheme.Colors.textPrimary)

                    Spacer()

                    Text(item.date, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }

                Text(item.detail.isEmpty ? "已记录" : item.detail)
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                    .lineLimit(2)
            }
        }
        .padding(AppTheme.Spacing.medium)
        .background(AppTheme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.Radius.medium)
                .stroke(AppTheme.Colors.separator.opacity(0.5), lineWidth: 1)
        }
    }
}
