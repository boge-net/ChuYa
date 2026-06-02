//
//  AppRootView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI
import SwiftData

struct AppRootView: View {
    @Query(sort: \BabyProfile.createdAt) private var babyProfiles: [BabyProfile]

    var body: some View {
        Group {
            if babyProfiles.first == nil {
                OnboardingView()
            } else {
                MainTabView()
            }
        }
    }
}

private struct MainTabView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("今日", systemImage: "sun.max")
                }

            RecordsView()
                .tabItem {
                    Label("记录", systemImage: "pencil.and.list.clipboard")
                }
            
            AskView()
                .tabItem {
                    Label("问问", systemImage: "bubble.left.and.bubble.right")
                }

            MonthGuideView()
                .tabItem {
                    Label("月龄", systemImage: "calendar")
                }

            CardsView()
                .tabItem {
                    Label("卡片", systemImage: "photo.on.rectangle")
                }
        }
        .tint(AppTheme.Colors.peach)
    }
}

#Preview {
    AppRootView()
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
