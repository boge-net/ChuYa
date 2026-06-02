//
//  BabyProfile.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import Foundation
import SwiftData

@Model
final class BabyProfile {
    var id: UUID
    var name: String
    var birthday: Date
    var gender: String
    var height: Double?
    var weight: Double?
    var feedingType: String
    var allergyNote: String?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        birthday: Date,
        gender: String,
        height: Double? = nil,
        weight: Double? = nil,
        feedingType: String,
        allergyNote: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.birthday = birthday
        self.gender = gender
        self.height = height
        self.weight = weight
        self.feedingType = feedingType
        self.allergyNote = allergyNote
        self.createdAt = createdAt
    }
}

