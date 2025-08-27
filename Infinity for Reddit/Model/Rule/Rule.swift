//
// Rule.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-24
        
import GRDB

public struct Rule: Codable, FetchableRecord, PersistableRecord, Identifiable {
    public static let databaseTableName = "rules"
    
    let shortName: String
    let descriptionHtml: String
    
    public var id: String {
        return self.shortName
    }
    
    init(shortName: String, descriptionHtml: String) {
        self.shortName = shortName
        self.descriptionHtml = descriptionHtml
    }
    
    private enum CodingKeys: String, CodingKey, ColumnExpression, CaseIterable {
        case shortName = "short_name"
        case descriptionHtml = "description_html"
    }
}
