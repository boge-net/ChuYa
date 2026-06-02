//
//  GrowthChartView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import Charts
import SwiftUI

struct GrowthChartView: View {
    let records: [GrowthRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("身高体重趋势")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundStyle(AppTheme.Colors.textPrimary)

            if chartPoints.isEmpty {
                EmptyStateCard(
                    systemImage: "chart.xyaxis.line",
                    title: "还没有身高体重记录",
                    message: "添加一条身高或体重记录后，这里会显示宝宝的成长趋势。"
                )
            } else {
                Chart(chartPoints) { point in
                    LineMark(
                        x: .value("日期", point.date),
                        y: .value(point.series.title, point.value)
                    )
                    .foregroundStyle(by: .value("类型", point.series.title))

                    PointMark(
                        x: .value("日期", point.date),
                        y: .value(point.series.title, point.value)
                    )
                    .foregroundStyle(by: .value("类型", point.series.title))
                }
                .chartForegroundStyleScale([
                    GrowthSeries.height.title: AppTheme.Colors.sprout,
                    GrowthSeries.weight.title: AppTheme.Colors.peach
                ])
                .frame(height: 220)
                .padding(AppTheme.Spacing.medium)
                .background(AppTheme.Colors.card)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.large))
                .overlay {
                    RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                        .stroke(AppTheme.Colors.separator.opacity(0.58), lineWidth: 1)
                }
            }
        }
    }

    private var chartPoints: [GrowthChartPoint] {
        records.flatMap { record in
            var points: [GrowthChartPoint] = []

            if let height = record.height {
                points.append(GrowthChartPoint(date: record.date, series: .height, value: height))
            }

            if let weight = record.weight {
                points.append(GrowthChartPoint(date: record.date, series: .weight, value: weight))
            }

            return points
        }
    }
}

private struct GrowthChartPoint: Identifiable {
    let id = UUID()
    let date: Date
    let series: GrowthSeries
    let value: Double
}

private enum GrowthSeries {
    case height
    case weight

    var title: String {
        switch self {
        case .height:
            return "身高 cm"
        case .weight:
            return "体重 kg"
        }
    }
}

#Preview {
    GrowthChartView(records: [])
}
