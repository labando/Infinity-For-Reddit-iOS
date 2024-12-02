//
//  LoginView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-01.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    
    func getLoginURL() -> URL {
        // Define the OAuth URL components
        let baseURL = URL(string: APIUtils.OAUTH_URL)!
        
        // Build the query parameters
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: APIUtils.CLIENT_ID_KEY, value: APIUtils.CLIENT_ID),
            URLQueryItem(name: APIUtils.RESPONSE_TYPE_KEY, value: APIUtils.RESPONSE_TYPE),
            URLQueryItem(name: APIUtils.STATE_KEY, value: APIUtils.STATE),
            URLQueryItem(name: APIUtils.REDIRECT_URI_KEY, value: APIUtils.REDIRECT_URI),
            URLQueryItem(name: APIUtils.DURATION_KEY, value: APIUtils.DURATION),
            URLQueryItem(name: APIUtils.SCOPE_KEY, value: APIUtils.SCOPE)
        ]
        
        // Get the final URL with the query parameters
        return components.url!
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                WebView(url: getLoginURL())
            }
            .navigationBarTitle("Login", displayMode: .inline)
        }
    }
}
