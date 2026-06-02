//
//  AIServiceProtocol.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import Foundation

protocol AIServiceProtocol {
    func answer(question: String, baby: BabyProfile?) -> String
}

