//
// RedditAccessTokenProviderProtocol.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-14

import Foundation

public protocol RedditAccessTokenProviderProtocol: Sendable {
    func getAccessToken(accountName: String) async -> String?
    func refreshAccessToken(accountName: String) async throws -> String
}
