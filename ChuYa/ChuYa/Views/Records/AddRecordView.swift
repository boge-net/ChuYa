//
//  AddRecordView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI
import SwiftData
import UIKit

struct AddRecordView: View {
    let baby: BabyProfile

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var recordType: RecordType = .growth
    @State private var date = Date()
    @State private var height = ""
    @State private var weight = ""
    @State private var feedingType = "母乳"
    @State private var feedingAmount = ""
    @State private var foodName = ""
    @State private var sleepStart = Date()
    @State private var sleepEnd = Date().addingTimeInterval(3600)
    @State private var stoolColor = ""
    @State private var stoolShape = ""
    @State private var note = ""

    private let feedingTypes = ["母乳", "奶粉", "混合", "辅食", "水"]

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                        Picker("记录类型", selection: $recordType) {
                            ForEach(RecordType.allCases) { type in
                                Text(type.title).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)

                        formFields
                    }
                    .padding(AppTheme.Spacing.large)
                }
            }
            .navigationTitle("添加记录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveRecord()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    @ViewBuilder
    private var formFields: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            DatePicker("记录时间", selection: $date)

            switch recordType {
            case .growth:
                LabeledTextField(title: "身高 cm", placeholder: "例如 62", text: $height, keyboardType: .decimalPad)
                LabeledTextField(title: "体重 kg", placeholder: "例如 6.5", text: $weight, keyboardType: .decimalPad)

            case .feeding:
                Picker("喂养类型", selection: $feedingType) {
                    ForEach(feedingTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                .pickerStyle(.menu)

                LabeledTextField(title: "奶量 ml", placeholder: "可选", text: $feedingAmount, keyboardType: .decimalPad)
                LabeledTextField(title: "食物名称", placeholder: "可选，例如 米糊", text: $foodName)

            case .sleep:
                DatePicker("开始时间", selection: $sleepStart, displayedComponents: [.hourAndMinute])
                DatePicker("结束时间", selection: $sleepEnd, displayedComponents: [.hourAndMinute])

            case .stool:
                LabeledTextField(title: "颜色", placeholder: "可选，例如 黄色", text: $stoolColor)
                LabeledTextField(title: "形态", placeholder: "可选，例如 糊状", text: $stoolShape)
            }

            LabeledTextField(title: "备注", placeholder: "可选", text: $note)
        }
        .font(AppTheme.Typography.body)
        .foregroundStyle(AppTheme.Colors.textPrimary)
        .padding(AppTheme.Spacing.large)
        .background(AppTheme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.large))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                .stroke(AppTheme.Colors.separator.opacity(0.58), lineWidth: 1)
        }
    }

    private var canSave: Bool {
        switch recordType {
        case .growth:
            return Double(height.trimmed) != nil || Double(weight.trimmed) != nil || !note.trimmed.isEmpty
        case .feeding:
            return !feedingType.isEmpty || Double(feedingAmount.trimmed) != nil || !foodName.trimmed.isEmpty || !note.trimmed.isEmpty
        case .sleep:
            return true
        case .stool:
            return !stoolColor.trimmed.isEmpty || !stoolShape.trimmed.isEmpty || !note.trimmed.isEmpty
        }
    }

    private func saveRecord() {
        switch recordType {
        case .growth:
            modelContext.insert(
                GrowthRecord(
                    babyId: baby.id,
                    date: date,
                    height: Double(height.trimmed),
                    weight: Double(weight.trimmed),
                    note: note.optionalTrimmed
                )
            )

        case .feeding:
            modelContext.insert(
                FeedingRecord(
                    babyId: baby.id,
                    date: date,
                    type: feedingType,
                    amount: Double(feedingAmount.trimmed),
                    foodName: foodName.optionalTrimmed,
                    note: note.optionalTrimmed
                )
            )

        case .sleep:
            modelContext.insert(
                SleepRecord(
                    babyId: baby.id,
                    date: date,
                    startTime: sleepStart,
                    endTime: sleepEnd,
                    note: note.optionalTrimmed
                )
            )

        case .stool:
            modelContext.insert(
                StoolRecord(
                    babyId: baby.id,
                    date: date,
                    color: stoolColor.optionalTrimmed,
                    shape: stoolShape.optionalTrimmed,
                    note: note.optionalTrimmed
                )
            )
        }

        dismiss()
    }
}

private enum RecordType: String, CaseIterable, Identifiable {
    case growth
    case feeding
    case sleep
    case stool

    var id: String { rawValue }

    var title: String {
        switch self {
        case .growth:
            return "成长"
        case .feeding:
            return "喂养"
        case .sleep:
            return "睡眠"
        case .stool:
            return "便便"
        }
    }
}

private struct LabeledTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
            Text(title)
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.textSecondary)

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .chuyaField()
        }
    }
}

private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var optionalTrimmed: String? {
        let value = trimmed
        return value.isEmpty ? nil : value
    }
}

#Preview {
    AddRecordView(
        baby: BabyProfile(
            name: "小芽",
            birthday: Date(),
            gender: "女宝宝",
            feedingType: "母乳"
        )
    )
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
