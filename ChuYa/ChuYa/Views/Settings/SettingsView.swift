//
//  SettingsView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftData
import SwiftUI
import UIKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \BabyProfile.createdAt) private var babyProfiles: [BabyProfile]
    @Query private var growthRecords: [GrowthRecord]
    @Query private var feedingRecords: [FeedingRecord]
    @Query private var sleepRecords: [SleepRecord]
    @Query private var stoolRecords: [StoolRecord]
    @Query private var qaHistory: [QAHistory]
    @Query private var memoryCards: [MemoryCard]

    @State private var showingEditProfile = false
    @State private var showingClearConfirm = false
    @State private var showingFinalClearConfirm = false

    private var baby: BabyProfile? {
        babyProfiles.first
    }

    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                    profileSection
                    privacySection
                    disclaimerSection
                    clearDataSection
                }
                .padding(AppTheme.Spacing.large)
            }
        }
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditProfile) {
            if let baby {
                EditBabyProfileView(baby: baby)
            }
        }
        .alert("确认清除本地数据？", isPresented: $showingClearConfirm) {
            Button("取消", role: .cancel) { }
            Button("继续", role: .destructive) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    showingFinalClearConfirm = true
                }
            }
        } message: {
            Text("这会删除宝宝档案、记录、问答历史和卡片记录。")
        }
        .alert("最后确认", isPresented: $showingFinalClearConfirm) {
            Button("取消", role: .cancel) { }
            Button("清除全部数据", role: .destructive) {
                clearAllLocalData()
                dismiss()
            }
        } message: {
            Text("清除后无法在 App 内恢复。")
        }
    }

    private var profileSection: some View {
        SettingsCard(title: "宝宝资料", iconName: "person.crop.circle") {
            if let baby {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                    Text(baby.name)
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundStyle(AppTheme.Colors.textPrimary)

                    Text("\(baby.gender) · \(BabyAgeCalculator.calculate(from: baby.birthday).displayText) · \(baby.feedingType)")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(AppTheme.Colors.textSecondary)

                    Button {
                        showingEditProfile = true
                    } label: {
                        Label("编辑宝宝资料", systemImage: "pencil")
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .foregroundStyle(AppTheme.Colors.peach)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, AppTheme.Spacing.xSmall)
                }
            } else {
                Text("暂无宝宝资料")
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
        }
    }

    private var privacySection: some View {
        SettingsCard(title: "隐私说明", iconName: "lock.shield") {
            BulletList(items: [
                "第一版数据仅保存在本机。",
                "不上传云端，不做云同步。",
                "用户可以随时清除本地数据。",
                "育儿建议仅供参考，不能替代医生诊断。"
            ])
        }
    }

    private var disclaimerSection: some View {
        SettingsCard(title: "育儿内容免责声明", iconName: "exclamationmark.circle") {
            Text("初芽中的今日建议、月龄百科和问问回答仅供日常育儿参考，不能替代医生诊断、治疗建议或线下问诊。如宝宝出现明显不适、高风险症状或家长无法判断的情况，请及时咨询儿科医生。")
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .lineSpacing(3)
        }
    }

    private var clearDataSection: some View {
        SettingsCard(title: "本地数据", iconName: "trash") {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                Text("清除后会删除宝宝档案、成长记录、喂养记录、睡眠记录、便便记录、问答历史和卡片记录。")
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                    .lineSpacing(3)

                Button(role: .destructive) {
                    showingClearConfirm = true
                } label: {
                    Label("清除本地数据", systemImage: "trash")
                        .font(.system(.body, design: .rounded, weight: .semibold))
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func clearAllLocalData() {
        growthRecords.forEach(modelContext.delete)
        feedingRecords.forEach(modelContext.delete)
        sleepRecords.forEach(modelContext.delete)
        stoolRecords.forEach(modelContext.delete)
        qaHistory.forEach(modelContext.delete)
        memoryCards.forEach(modelContext.delete)
        babyProfiles.forEach(modelContext.delete)
    }
}

private struct SettingsCard<Content: View>: View {
    let title: String
    let iconName: String
    let content: Content

    init(title: String, iconName: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.iconName = iconName
        self.content = content()
    }

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

            content
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

private struct BulletList: View {
    let items: [String]

    var body: some View {
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
}

private struct EditBabyProfileView: View {
    let baby: BabyProfile

    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var birthday: Date
    @State private var gender: String
    @State private var height: String
    @State private var weight: String
    @State private var feedingType: String
    @State private var allergyNote: String

    private let genders = ["女宝宝", "男宝宝", "暂不填写"]
    private let feedingTypes = ["母乳", "奶粉", "混合", "已添加辅食"]

    init(baby: BabyProfile) {
        self.baby = baby
        _name = State(initialValue: baby.name)
        _birthday = State(initialValue: baby.birthday)
        _gender = State(initialValue: baby.gender)
        _height = State(initialValue: baby.height?.formatted(.number.precision(.fractionLength(0...1))) ?? "")
        _weight = State(initialValue: baby.weight?.formatted(.number.precision(.fractionLength(0...1))) ?? "")
        _feedingType = State(initialValue: baby.feedingType)
        _allergyNote = State(initialValue: baby.allergyNote ?? "")
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.dismissKeyboard()
                    }

                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                        profileField("宝宝昵称", text: $name)

                        DatePicker("宝宝生日", selection: $birthday, in: ...Date(), displayedComponents: .date)
                            .font(AppTheme.Typography.body)

                        Picker("性别", selection: $gender) {
                            ForEach(genders, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)

                        HStack(spacing: AppTheme.Spacing.medium) {
                            profileField("身高 cm", text: $height, keyboardType: .decimalPad)
                            profileField("体重 kg", text: $weight, keyboardType: .decimalPad)
                        }

                        Picker("喂养方式", selection: $feedingType) {
                            ForEach(feedingTypes, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu)

                        profileField("过敏备注", text: $allergyNote)
                    }
                    .padding(AppTheme.Spacing.large)
                    .background(AppTheme.Colors.card)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.large))
                    .padding(AppTheme.Spacing.large)
                }
                .scrollDismissesKeyboard(.immediately)
            }
            .navigationTitle("编辑宝宝资料")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        UIApplication.shared.dismissKeyboard()
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        UIApplication.shared.dismissKeyboard()
                        save()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func profileField(_ title: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
            Text(title)
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.textSecondary)

            TextField(title, text: text)
                .keyboardType(keyboardType)
                .chuyaField()
        }
    }

    private func save() {
        baby.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        baby.birthday = birthday
        baby.gender = gender
        baby.height = Double(height.trimmingCharacters(in: .whitespacesAndNewlines))
        baby.weight = Double(weight.trimmingCharacters(in: .whitespacesAndNewlines))
        baby.feedingType = feedingType

        let trimmedAllergyNote = allergyNote.trimmingCharacters(in: .whitespacesAndNewlines)
        baby.allergyNote = trimmedAllergyNote.isEmpty ? nil : trimmedAllergyNote
        dismiss()
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
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
