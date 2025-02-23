//
//  CustomThemeViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-10.
//

import Foundation
import Combine
import GRDB

public class CustomThemeViewModel: ObservableObject {
    // The default theme is Indigo
    @Published var currentCustomTheme: CustomTheme = CustomTheme.getIndigo()
    @Published var isDarkTheme: Bool = false
    @Published var allCustomThemes: [CustomTheme] = []
    @Published var currentLightCustomTheme: CustomTheme?
    @Published var currentDarkCustomTheme: CustomTheme?
    @Published var currentAmoledCustomTheme: CustomTheme?
    
    private let customThemeDao: CustomThemeDao
    private var cancellables = Set<AnyCancellable>()
    
    let allCustomThemesPublisher: AnyPublisher<[CustomTheme], Error>
    let currentLightCustomThemePublisher: AnyPublisher<CustomTheme?, Error>
    let currentDarkCustomThemePublisher: AnyPublisher<CustomTheme?, Error>
    let currentAmoledCustomThemePublisher: AnyPublisher<CustomTheme?, Error>
    
    init() {
        guard let resolvedDatabasePool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Could not resolve DatabasePool")
        }
        
        self.customThemeDao = CustomThemeDao(dbPool: resolvedDatabasePool)
        
        self.allCustomThemesPublisher = customThemeDao.getAllCustomThemesPublisher()
        self.currentLightCustomThemePublisher = customThemeDao.getLightCustomThemePublisher()
        self.currentDarkCustomThemePublisher = customThemeDao.getDarkCustomThemePublisher()
        self.currentAmoledCustomThemePublisher = customThemeDao.getAmoledCustomThemePublisher()
        
        allCustomThemesPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] themes in
                self?.allCustomThemes = themes
            })
            .store(in: &cancellables)
        
        currentLightCustomThemePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] theme in
                self?.currentLightCustomTheme = theme
            })
            .store(in: &cancellables)
        
        currentDarkCustomThemePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] theme in
                self?.currentDarkCustomTheme = theme
            })
            .store(in: &cancellables)
        
        currentAmoledCustomThemePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] theme in
                self?.currentAmoledCustomTheme = theme
            })
            .store(in: &cancellables)
    }
}
