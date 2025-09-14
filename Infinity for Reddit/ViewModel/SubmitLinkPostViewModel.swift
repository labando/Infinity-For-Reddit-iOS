//
// SubmitLinkPostViewModel.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-13

import Foundation
import MarkdownUI
import Alamofire

@MainActor
class SubmitLinkPostViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedAccount: Account
    @Published var selectedFlair: Flair?
    @Published var url: String = ""
    
    init() {
        self.selectedAccount = AccountViewModel.shared.account
    }
    
    func suggestTitle() {
        var finalURL = url.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !finalURL.lowercased().hasPrefix("http://") &&
            !finalURL.lowercased().hasPrefix("https://") {
            finalURL = "https://" + finalURL
        }
        
        guard var components = URLComponents(string: finalURL), let host = components.host else {
            print("Invalid URL: \(finalURL)")
            return
        }
        
        if !host.contains("www.") && host.components(separatedBy: ".").count == 2 {
            components.host = "www." + host
        }
        
        guard let safeURL = components.url else {
            print("Failed to build safe URL")
            return
        }
        
        print("Final safe URL: \(safeURL)")
        
        AF.request(safeURL, method: .get)
            .validate()
            .responseString { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let html):
                    if let start = html.range(of: "<title>", options: .caseInsensitive),
                       let end = html.range(of: "</title>", options: .caseInsensitive) {
                        let extracted = String(html[start.upperBound..<end.lowerBound])
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        Task { @MainActor in
                            self.title = extracted
                        }
                    } else {
                        print("No <title> found in HTML")
                    }
                    
                case .failure(let error):
                    print("Suggest title failed: \(error.localizedDescription)")
                }
            }
    }
}
