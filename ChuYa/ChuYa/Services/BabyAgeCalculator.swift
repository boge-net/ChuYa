//
//  BabyAgeCalculator.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import Foundation

struct BabyAgeInfo {
    let daysOld: Int
    let monthsOld: Int
    let years: Int
    let remainingMonths: Int
    let displayText: String
}

enum BabyAgeCalculator {
    static func calculate(from birthday: Date, to date: Date = Date(), calendar: Calendar = .current) -> BabyAgeInfo {
        let startOfBirthday = calendar.startOfDay(for: birthday)
        let startOfDate = calendar.startOfDay(for: date)
        let normalizedDate = max(startOfBirthday, startOfDate)

        let daysOld = calendar.dateComponents([.day], from: startOfBirthday, to: normalizedDate).day ?? 0
        let monthsOld = calendar.dateComponents([.month], from: startOfBirthday, to: normalizedDate).month ?? 0
        let years = monthsOld / 12
        let remainingMonths = monthsOld % 12

        return BabyAgeInfo(
            daysOld: daysOld,
            monthsOld: monthsOld,
            years: years,
            remainingMonths: remainingMonths,
            displayText: displayText(years: years, months: remainingMonths, days: daysOld)
        )
    }

    private static func displayText(years: Int, months: Int, days: Int) -> String {
        if years > 0 {
            return months > 0 ? "\(years) 岁 \(months) 个月" : "\(years) 岁"
        }

        if months > 0 {
            return "\(months) 个月"
        }

        return "\(days) 天"
    }
}

