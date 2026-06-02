//
//  SleepRecord.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import Foundation
import SwiftData

@Model
final class SleepRecord {
    var id: UUID
    var babyId: UUID
    var date: Date
    var startTime: Date
    var endTime: Date
    var note: String?

    init(
        id: UUID = UUID(),
        babyId: UUID,
        date: Date = Date(),
        startTime: Date,
        endTime: Date,
        note: String? = nil
    ) {
        self.id = id
        self.babyId = babyId
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.note = note
    }
}

