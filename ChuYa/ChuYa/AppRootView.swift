//
//  AppRootView.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI
import SwiftData
import UIKit

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
    @State private var selectedTab = MainTab.today

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem {
                    Label("今日", systemImage: "sun.max")
                }
                .tag(MainTab.today)

            RecordsView()
                .tabItem {
                    Label("记录", systemImage: "pencil.and.list.clipboard")
                }
                .tag(MainTab.records)
            
            AskView()
                .tabItem {
                    Label("问问", systemImage: "bubble.left.and.bubble.right")
                }
                .tag(MainTab.ask)

            MonthGuideView()
                .tabItem {
                    Label("月龄", systemImage: "calendar")
                }
                .tag(MainTab.monthGuide)

            CardsView()
                .tabItem {
                    Label("卡片", systemImage: "photo.on.rectangle")
                }
                .tag(MainTab.cards)
        }
        .tint(AppTheme.Colors.peach)
        .onChange(of: selectedTab) {
            UIApplication.shared.dismissKeyboard()
        }
    }
}

private enum MainTab: Hashable {
    case today
    case records
    case ask
    case monthGuide
    case cards
}

extension UIApplication {
    func dismissKeyboard() {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .forEach { $0.endEditing(true) }

        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
