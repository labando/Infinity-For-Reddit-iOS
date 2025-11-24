//
// Rule.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-24
        
import GRDB

public struct Rule {
    let shortName: String
    let description: String
    
    init(shortName: String, description: String) {
        self.shortName = shortName
        self.description = description
    }
}
