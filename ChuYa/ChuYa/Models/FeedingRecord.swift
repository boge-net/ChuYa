//
//  FeedingRecord.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import Foundation
import SwiftData

@Model
final class FeedingRecord {
    var id: UUID
    var babyId: UUID
    var date: Date
    var type: String
    var amount: Double?
    var foodName: String?
    var note: String?

    init(
        id: UUID = UUID(),
        babyId: UUID,
        date: Date = Date(),
        type: String,
        amount: Double? = nil,
        foodName: String? = nil,
        note: String? = nil
    ) {
        self.id = id
        self.babyId = babyId
        self.date = date
        self.type = type
        self.amount = amount
        self.foodName = foodName
        self.note = note
    }
}

