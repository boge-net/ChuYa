//
//  CardsView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI
import SwiftData
import PhotosUI
import UIKit

struct CardsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.displayScale) private var displayScale

    @Query(sort: \BabyProfile.createdAt) private var babyProfiles: [BabyProfile]
    @Query(sort: \MemoryCard.createdAt, order: .reverse) private var memoryCards: [MemoryCard]

    @State private var selectedTemplate = CardTemplate.fullMoon
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var title = "满月快乐"
    @State private var subtitle = "每天一点，陪宝宝长大。"
    @State private var exportMessage: String?
    @State private var isSaving = false

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
                        header
                        templateSection
                        editorSection
                        previewSection
                        saveButton

                        if let exportMessage {
                            Text(exportMessage)
                                .font(AppTheme.Typography.caption)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        savedCardsSection
                    }
                    .padding(AppTheme.Spacing.large)
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    await loadImage(from: newItem)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
            Text("卡片")
                .font(AppTheme.Typography.title)
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Text("为宝宝留下温柔的纪念。")
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
    }

    private var templateSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("选择模板")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundStyle(AppTheme.Colors.textPrimary)

            ForEach(CardTemplate.all) { template in
                Button {
                    selectedTemplate = template
                    title = defaultTitle(for: template)
                    subtitle = defaultSubtitle(for: template)
                } label: {
                    CardTemplateView(template: template, isSelected: selectedTemplate.id == template.id)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var editorSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("编辑内容")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundStyle(AppTheme.Colors.textPrimary)

            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                    Text(selectedImage == nil ? "选择宝宝照片" : "更换宝宝照片")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .padding(AppTheme.Spacing.medium)
                .background(AppTheme.Colors.card)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                Text("标题")
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                TextField("例如：满月快乐", text: $title)
                    .cardsTextFieldStyle()
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                Text("副标题")
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                TextField("例如：每天一点，陪宝宝长大。", text: $subtitle, axis: .vertical)
                    .lineLimit(1...3)
                    .cardsTextFieldStyle()
            }
        }
        .padding(AppTheme.Spacing.large)
        .background(AppTheme.Colors.card.opacity(0.62))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.large))
    }

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("卡片预览")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundStyle(AppTheme.Colors.textPrimary)

            CardPreviewView(
                template: selectedTemplate,
                babyName: baby?.name ?? "宝宝",
                title: title,
                subtitle: subtitle,
                image: selectedImage
            )
        }
    }

    private var saveButton: some View {
        Button {
            Task {
                await saveCard()
            }
        } label: {
            HStack {
                if isSaving {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "square.and.arrow.down")
                }
                Text(isSaving ? "正在保存" : "保存到相册")
            }
            .font(.system(.headline, design: .rounded, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.medium)
            .background(canSave ? AppTheme.Colors.peach : AppTheme.Colors.disabled.opacity(0.55))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
        }
        .buttonStyle(.plain)
        .disabled(!canSave || isSaving)
    }

    private var savedCardsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("已保存记录")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundStyle(AppTheme.Colors.textPrimary)

            if savedCards.isEmpty {
                EmptyStateCard(
                    systemImage: "rectangle.stack",
                    title: "还没有卡片记录",
                    message: "保存第一张卡片后，这里会记录模板和标题，方便之后回看。"
                )
            } else {
                ForEach(savedCards) { card in
                    HStack {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                            Text(card.title)
                                .font(.system(.body, design: .rounded, weight: .semibold))
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                            Text("\(card.templateName) · \(card.createdAt.formatted(date: .abbreviated, time: .omitted))")
                                .font(AppTheme.Typography.caption)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(AppTheme.Spacing.medium)
                    .background(AppTheme.Colors.card)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
                }
            }
        }
    }

    private var savedCards: [MemoryCard] {
        guard let babyId = baby?.id else { return [] }
        return memoryCards.filter { $0.babyId == babyId }
    }

    private var canSave: Bool {
        baby != nil && !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func loadImage(from item: PhotosPickerItem?) async {
        guard let item else { return }

        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImage = image
            }
        } catch {
            exportMessage = "照片读取失败，请重新选择。"
        }
    }

    private func saveCard() async {
        guard let baby else { return }

        isSaving = true
        defer { isSaving = false }

        let exportView = CardPreviewView(
            template: selectedTemplate,
            babyName: baby.name,
            title: title,
            subtitle: subtitle,
            image: selectedImage
        )
        let image = ImageExportService.renderImage(
            from: exportView,
            size: CGSize(width: 900, height: 1250),
            scale: displayScale
        )

        do {
            try await ImageExportService.saveToPhotoLibrary(image)
            modelContext.insert(
                MemoryCard(
                    babyId: baby.id,
                    templateName: selectedTemplate.name,
                    title: title,
                    subtitle: subtitle
                )
            )
            exportMessage = "已保存到相册。"
        } catch {
            exportMessage = error.localizedDescription
        }
    }

    private func defaultTitle(for template: CardTemplate) -> String {
        switch template.id {
        case CardTemplate.fullMoon.id:
            return "满月快乐"
        case CardTemplate.hundredDays.id:
            return "百天快乐"
        case CardTemplate.birthday.id:
            return "生日快乐"
        default:
            return template.name
        }
    }

    private func defaultSubtitle(for template: CardTemplate) -> String {
        baby.map { "\($0.name) · \(template.caption)" } ?? template.caption
    }
}

#Preview {
    CardsView()
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

private extension View {
    func cardsTextFieldStyle() -> some View {
        self
            .chuyaField()
    }
}
