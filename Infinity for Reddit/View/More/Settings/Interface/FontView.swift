//
// FontView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-05
//

import SwiftUI
import Swinject
import GRDB

struct FontView: View {
    @Environment(\.dependencyManager) private var dependencyManager: Container
    @State private var fontFamily: Int
    @State private var fontSize: Int
    @State private var titleFontFamily: Int
    @State private var titleFontSize: Int
    @State private var contentFontFamily: Int
    @State private var contentFontSize: Int
    private let families: [String] = ["Default", "Balsamiq Sans", "Balsamiq Sans Bold", "Noto Sans", "Noto Sans Bold", "Harmonia Sans", "Harmonia Sans Bold (No Italic)", "Roboto Condensed", "Roboto Condensed Bold", "Inter (No Italic)", "Inter Bold (No Italic)", "Manrope (No Italic)", "Manrope Bold (No Italic)", "Sriracha", "Atkinson Hyperlegible", "Atkinson Hyperlegible Bold", "Custom Font Family"]
    private let sizes: [String] = ["Extra Small", "Small", "Normal", "Large", "Extra Large"]
    private let contentSizes: [String] = ["Extra Small", "Small", "Normal", "Large", "Extra Large", "Enormously Large"]

    private let userDefaults: UserDefaults
    
    init() {
        guard let resolvedUserDefaults = DependencyManager.shared.container.resolve(UserDefaults.self) else {
            fatalError("Failed to resolve UserDefaults")
        }
        self.userDefaults = resolvedUserDefaults
        
        if userDefaults.object(forKey: "FONT_FAMILY_KEY") == nil {
            userDefaults.set(0, forKey: "FONT_FAMILY_KEY")
        }
        
        if userDefaults.object(forKey: "FONT_SIZE_KEY") == nil {
            userDefaults.set(2, forKey: "FONT_SIZE_KEY")
        }
        
        if userDefaults.object(forKey: "TITLE_FONT_FAMILY_KEY") == nil {
            userDefaults.set(0, forKey: "TITLE_FONT_FAMILY_KEY")
        }
        
        if userDefaults.object(forKey: "TITLE_FONT_SIZE_KEY") == nil {
            userDefaults.set(2, forKey: "TITLE_FONT_SIZE_KEY")
        }
        
        if userDefaults.object(forKey: "CONTENT_FONT_FAMILY_KEY") == nil {
            userDefaults.set(0, forKey: "CONTENT_FONT_FAMILY_KEY")
        }
        
        if userDefaults.object(forKey: "CONTENT_FONT_SIZE_KEY") == nil {
            userDefaults.set(2, forKey: "CONTENT_FONT_SIZE_KEY")
        }
        
        _fontFamily = State(initialValue: userDefaults.integer(forKey: "FONT_FAMILY_KEY"))
        _fontSize = State(initialValue: userDefaults.integer(forKey: "FONT_SIZE_KEY"))
        _titleFontFamily = State(initialValue: userDefaults.integer(forKey: "TITLE_FONT_FAMILY_KEY"))
        _titleFontSize = State(initialValue: userDefaults.integer(forKey: "TITLE_FONT_SIZE_KEY"))
        _contentFontFamily = State(initialValue: userDefaults.integer(forKey: "CONTENT_FONT_FAMILY_KEY"))
        _contentFontSize = State(initialValue: userDefaults.integer(forKey: "CONTENT_FONT_SIZE_KEY"))
    }
    
    var body: some View {
        List{
            Section{
                NavigationLink(destination: FontView()){
                    Text("Font Preview").padding(.leading, 44.5)
                }
            }
            Section(header: Text("Font")){
                Picker("Font Family", selection: $fontFamily){
                    ForEach(0..<families.count, id: \.self) { index in
                        Text(families[index]).tag(index)
                    }
                }
                .padding(.leading, 44.5)
                .onChange(of: fontFamily) { _, newValue in
                    userDefaults.set(newValue, forKey: "FONT_FAMILY_KEY")
                }
                Picker("Font Size", selection: $fontSize){
                    ForEach(0..<sizes.count, id: \.self) { index in
                        Text(sizes[index]).tag(index)
                    }
                }
                .padding(.leading, 44.5)
                .onChange(of: fontSize) { _, newValue in
                    userDefaults.set(newValue, forKey: "FONT_SIZE_KEY")
                }
            }
            Section(header: Text("Title")){
                Picker("Title Font Family", selection: $titleFontFamily){
                    ForEach(0..<families.count, id: \.self) { index in
                        Text(families[index]).tag(index)
                    }
                }
                .padding(.leading, 44.5)
                .onChange(of: titleFontFamily) { _, newValue in
                    userDefaults.set(newValue, forKey: "TITLE_FONT_FAMILY_KEY")
                }
                Picker("Title Font Size", selection: $titleFontSize){
                    ForEach(0..<sizes.count, id: \.self) { index in
                        Text(sizes[index]).tag(index)
                    }
                }
                .padding(.leading, 44.5)
                .onChange(of: titleFontSize) { _, newValue in
                    userDefaults.set(newValue, forKey: "TITLE_FONT_SIZE_KEY")
                }
            }
            Section(header: Text("Content")){
                Picker("Content Font Family", selection: $contentFontFamily){
                    ForEach(0..<families.count, id: \.self) { index in
                        Text(families[index]).tag(index)
                    }
                }
                .padding(.leading, 44.5)
                .onChange(of: contentFontFamily) { _, newValue in
                    userDefaults.set(newValue, forKey: "CONTENT_FONT_FAMILY_KEY")
                }
                Picker("Content Font Size", selection: $contentFontSize){
                    ForEach(0..<contentSizes.count, id: \.self) { index in
                        Text(contentSizes[index]).tag(index)
                    }
                }
                .padding(.leading, 44.5)
                .onChange(of: contentFontSize) { _, newValue in
                    userDefaults.set(newValue, forKey: "CONTENT_FONT_SIZE_KEY")
                }
            }
        }
    }
}
