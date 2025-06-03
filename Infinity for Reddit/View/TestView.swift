//
//  TestView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-22.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject private var namespaceManager: NamespaceManager
    
    @State private var flip: Bool = false
    
    var body: some View {
        ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.white)
                        .shadow(radius: 10)
                        .padding(10)

                    VStack {
                        Text("card.prompt")
                            .font(.largeTitle)
                            .foregroundStyle(.black)

                        Text("card.answer")
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                    .padding(20)
                    .multilineTextAlignment(.center)
                }
                .frame(width: 250, height: 250)
    }
}

#Preview(traits: .fixedLayout(width: 400, height: 60)) {
    return TestView()
        .background(Color.red)
}
