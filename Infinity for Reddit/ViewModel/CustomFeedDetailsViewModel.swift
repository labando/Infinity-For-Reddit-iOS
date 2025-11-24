//
//  CustomFeedDetailsViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-27.
//

import Foundation

public class CustomFeedDetailsViewModel: ObservableObject {
    @Published var customFeed: CustomFeedWrapper
    private let customFeedDetailsRepository: CustomFeedDetailsRepositoryProtocol
    
    init(customFeed: CustomFeedWrapper, customFeedDetailsRepository: CustomFeedDetailsRepositoryProtocol) {
        self.customFeed = customFeed
        self.customFeedDetailsRepository = customFeedDetailsRepository
    }
}
