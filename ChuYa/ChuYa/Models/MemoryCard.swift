//
//  MemoryCard.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import Foundation
import SwiftData

@Model
final class MemoryCard {
    var id: UUID
    var babyId: UUID
    var templateName: String
    var title: String
    var subtitle: String
    var imagePath: String?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        babyId: UUID,
        templateName: String,
        title: String,
        subtitle: String,
        imagePath: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.babyId = babyId
        self.templateName = templateName
        self.title = title
        self.subtitle = subtitle
        self.imagePath = imagePath
        self.createdAt = createdAt
    }
}

