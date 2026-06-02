//
//  QAHistory.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import Foundation
import SwiftData

@Model
final class QAHistory {
    var id: UUID
    var babyId: UUID
    var question: String
    var answer: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        babyId: UUID,
        question: String,
        answer: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.babyId = babyId
        self.question = question
        self.answer = answer
        self.createdAt = createdAt
    }
}

