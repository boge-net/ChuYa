//
//  CardPreviewView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI
import UIKit

struct CardPreviewView: View {
    let template: CardTemplate
    let babyName: String
    let title: String
    let subtitle: String
    let image: UIImage?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [AppTheme.Colors.card, template.accent.opacity(0.22)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 18) {
                photoArea

                VStack(spacing: 8) {
                    Text(title.isEmpty ? template.name : title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.72)

                    Text(subtitle.isEmpty ? "\(babyName) · \(template.caption)" : subtitle)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .minimumScaleFactor(0.75)
                }

                HStack(spacing: 8) {
                    Image(systemName: template.symbolName)
                    Text("初芽")
                }
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(template.accent)
            }
            .padding(26)
        }
        .aspectRatio(0.72, contentMode: .fit)
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .stroke(.white.opacity(0.75), lineWidth: 1)
        }
    }

    @ViewBuilder
    private var photoArea: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.white.opacity(0.78), lineWidth: 1)
                }
        } else {
            RoundedRectangle(cornerRadius: 24)
                .fill(.white.opacity(0.52))
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    VStack(spacing: 10) {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                        Text("选择宝宝照片")
                            .font(AppTheme.Typography.body)
                    }
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                }
        }
    }
}

#Preview {
    CardPreviewView(
        template: .fullMoon,
        babyName: "小芽",
        title: "满月快乐",
        subtitle: "每天一点，陪宝宝长大。",
        image: nil
    )
    .padding()
    .background(AppTheme.Colors.background)
}

