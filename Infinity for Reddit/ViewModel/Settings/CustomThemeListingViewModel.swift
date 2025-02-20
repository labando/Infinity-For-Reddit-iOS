//
//  CustomThemeListingViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-20.
//

import Foundation
import Combine
import GRDB

class CustomThemeListingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var customThemes: [CustomTheme] = []
    
    // MARK: - Dependencies
    private var customThemeDao: CustomThemeDao
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializer
    init() {
        guard let resolvedDatabasePool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Could not resolve DatabasePool")
        }
        
        self.customThemeDao = CustomThemeDao(dbPool: resolvedDatabasePool)
        
        subscribeToThemes()
    }
    
    func subscribeToThemes() {
        customThemeDao.getAllCustomThemesPublisher()
            .receive(on: DispatchQueue.main) // Ensure updates happen on the main thread
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching themes: \(error)")
                }
            }, receiveValue: { [weak self] themes in
                self?.customThemes = themes
            })
            .store(in: &cancellables)
    }
}
