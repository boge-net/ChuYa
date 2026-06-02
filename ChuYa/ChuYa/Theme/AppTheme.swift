//
//  AppTheme.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import SwiftUI
import UIKit

enum AppTheme {
    enum Colors {
        static let background = adaptive(light: UIColor(red: 0.99, green: 0.96, blue: 0.91, alpha: 1), dark: UIColor(red: 0.12, green: 0.10, blue: 0.09, alpha: 1))
        static let card = adaptive(light: UIColor(red: 1.0, green: 0.99, blue: 0.97, alpha: 1), dark: UIColor(red: 0.18, green: 0.15, blue: 0.14, alpha: 1))
        static let field = adaptive(light: UIColor(red: 1.0, green: 0.98, blue: 0.95, alpha: 1), dark: UIColor(red: 0.23, green: 0.20, blue: 0.18, alpha: 1))
        static let peach = adaptive(light: UIColor(red: 0.94, green: 0.55, blue: 0.44, alpha: 1), dark: UIColor(red: 0.96, green: 0.62, blue: 0.52, alpha: 1))
        static let peachSoft = adaptive(light: UIColor(red: 1.0, green: 0.82, blue: 0.76, alpha: 1), dark: UIColor(red: 0.42, green: 0.22, blue: 0.19, alpha: 1))
        static let sprout = adaptive(light: UIColor(red: 0.55, green: 0.72, blue: 0.55, alpha: 1), dark: UIColor(red: 0.62, green: 0.78, blue: 0.62, alpha: 1))
        static let lavender = adaptive(light: UIColor(red: 0.68, green: 0.62, blue: 0.82, alpha: 1), dark: UIColor(red: 0.72, green: 0.68, blue: 0.88, alpha: 1))
        static let textPrimary = adaptive(light: UIColor(red: 0.20, green: 0.18, blue: 0.17, alpha: 1), dark: UIColor(red: 0.94, green: 0.91, blue: 0.87, alpha: 1))
        static let textSecondary = adaptive(light: UIColor(red: 0.52, green: 0.47, blue: 0.43, alpha: 1), dark: UIColor(red: 0.74, green: 0.69, blue: 0.64, alpha: 1))
        static let separator = adaptive(light: UIColor(red: 0.90, green: 0.84, blue: 0.78, alpha: 1), dark: UIColor(red: 0.33, green: 0.29, blue: 0.26, alpha: 1))
        static let disabled = adaptive(light: UIColor(red: 0.68, green: 0.62, blue: 0.58, alpha: 1), dark: UIColor(red: 0.42, green: 0.38, blue: 0.35, alpha: 1))

        private static func adaptive(light: UIColor, dark: UIColor) -> Color {
            Color(UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? dark : light
            })
        }
    }

    enum Radius {
        static let small: CGFloat = 10
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }

    enum Spacing {
        static let xSmall: CGFloat = 6
        static let small: CGFloat = 10
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xLarge: CGFloat = 32
    }

    enum Typography {
        static let title = Font.system(.largeTitle, design: .rounded, weight: .bold)
        static let sectionTitle = Font.system(.title3, design: .rounded, weight: .semibold)
        static let body = Font.system(.body, design: .rounded)
        static let caption = Font.system(.footnote, design: .rounded)
    }
}
