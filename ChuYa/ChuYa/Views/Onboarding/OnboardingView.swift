//
//  OnboardingView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var birthday = Date()
    @State private var gender = "女宝宝"
    @State private var height = ""
    @State private var weight = ""
    @State private var feedingType = "母乳"
    @State private var allergyNote = ""

    private let genders = ["女宝宝", "男宝宝", "暂不填写"]
    private let feedingTypes = ["母乳", "奶粉", "混合", "已添加辅食"]

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                        header
                        formCard
                        saveButton
                    }
                    .padding(AppTheme.Spacing.large)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("欢迎来到初芽")
                .font(AppTheme.Typography.title)
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Text("先创建宝宝档案，之后每天都会根据月龄给出更贴近当下的养育提醒。")
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .lineSpacing(3)
        }
    }

    private var formCard: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                FieldLabel("宝宝昵称")
                TextField("例如：小芽", text: $name)
                    .textInputAutocapitalization(.never)
                    .appTextFieldStyle()
            }

            DatePicker("宝宝生日", selection: $birthday, in: ...Date(), displayedComponents: .date)
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Picker("性别", selection: $gender) {
                ForEach(genders, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.segmented)

            HStack(spacing: AppTheme.Spacing.medium) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                    FieldLabel("当前身高")
                    TextField("cm", text: $height)
                        .keyboardType(.decimalPad)
                        .appTextFieldStyle()
                }

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                    FieldLabel("当前体重")
                    TextField("kg", text: $weight)
                        .keyboardType(.decimalPad)
                        .appTextFieldStyle()
                }
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                FieldLabel("喂养方式")
                Picker("喂养方式", selection: $feedingType) {
                    ForEach(feedingTypes, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .chuyaField()
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                FieldLabel("过敏备注")
                TextField("可选，例如：鸡蛋过敏", text: $allergyNote, axis: .vertical)
                    .lineLimit(2...4)
                    .appTextFieldStyle()
            }
        }
        .padding(AppTheme.Spacing.large)
        .background(AppTheme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.large))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                .stroke(AppTheme.Colors.separator.opacity(0.6), lineWidth: 1)
        }
    }

    private var saveButton: some View {
        Button {
            saveBabyProfile()
        } label: {
            Text("保存并进入初芽")
        }
        .buttonStyle(PrimaryActionButtonStyle(isEnabled: canSave))
        .disabled(!canSave)
    }

    private func saveBabyProfile() {
        let profile = BabyProfile(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            birthday: birthday,
            gender: gender,
            height: Double(height.trimmingCharacters(in: .whitespacesAndNewlines)),
            weight: Double(weight.trimmingCharacters(in: .whitespacesAndNewlines)),
            feedingType: feedingType,
            allergyNote: sanitizedOptionalText(allergyNote)
        )

        modelContext.insert(profile)
    }

    private func sanitizedOptionalText(_ text: String) -> String? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}

private struct FieldLabel: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(AppTheme.Typography.caption)
            .foregroundStyle(AppTheme.Colors.textSecondary)
    }
}

private extension View {
    func appTextFieldStyle() -> some View {
        self
            .chuyaField()
    }
}

#Preview {
    OnboardingView()
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
