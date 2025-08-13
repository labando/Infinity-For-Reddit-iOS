//
//  TestView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-22.
//

import SwiftUI
import SDWebImageSwiftUI

struct DummyListItem: Identifiable {
    let id: Int // The Int itself serves as the unique identifier
    // Add any other dummy properties you might need for your ItemView later
    // var someText: String
    // var imageUrl: URL? // If you plan to use WebImage with it
}

struct TestView: View {
    @State var showView : Bool = false
        
        var body: some View {
            VStack {
                
                //Button to toggle the showView boolean
                Button(action: {
                    withAnimation{
                             self.showView.toggle()
                          }
                }) {
                    Text("Change state")
                        .primaryText()
                }
                
                //Show the red square if showView is true
                if self.showView{
                    Color.red
                    .frame(width: 100, height: 100)
                    .transition(.move(edge: .bottom))
                }
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
}
