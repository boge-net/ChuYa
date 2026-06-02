//
//  Item.swift
//  ChuYa
//
//  Created by cc on 2026-06-01.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
