//
//  GrowthRecord.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import Foundation
import SwiftData

@Model
final class GrowthRecord {
    var id: UUID
    var babyId: UUID
    var date: Date
    var height: Double?
    var weight: Double?
    var note: String?

    init(
        id: UUID = UUID(),
        babyId: UUID,
        date: Date = Date(),
        height: Double? = nil,
        weight: Double? = nil,
        note: String? = nil
    ) {
        self.id = id
        self.babyId = babyId
        self.date = date
        self.height = height
        self.weight = weight
        self.note = note
    }
}

