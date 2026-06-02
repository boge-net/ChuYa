//
//  StoolRecord.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import Foundation
import SwiftData

@Model
final class StoolRecord {
    var id: UUID
    var babyId: UUID
    var date: Date
    var color: String?
    var shape: String?
    var note: String?

    init(
        id: UUID = UUID(),
        babyId: UUID,
        date: Date = Date(),
        color: String? = nil,
        shape: String? = nil,
        note: String? = nil
    ) {
        self.id = id
        self.babyId = babyId
        self.date = date
        self.color = color
        self.shape = shape
        self.note = note
    }
}

