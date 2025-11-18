//
//  SelectUserFlairSheet.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-17.
//

import SwiftUI

struct SelectUserFlairSheet: View {
    @Environment(\.dismiss) var dismiss
    
    let userFlairs: [UserFlair]?
    let onUserFlairSelected: (UserFlair) -> Void
    
    var body: some View {
        ScrollView {
            if let userFlairs {
                VStack(spacing: 0) {
                    if !userFlairs.isEmpty {
                        ForEach(userFlairs, id: \.id) { userFlair in
                            TouchRipple(action: {
                                onUserFlairSelected(userFlair)
                                dismiss()
                            }) {
                                UserFlairRowView(userFlair: userFlair)
                            }
                        }
                    } else {
                        Text("No user flairs available")
                            .secondaryText()
                    }
                }
                .padding(.top, 20)
            } else {
                ZStack {
                    ProgressIndicator()
                }
                .frame(height: 80)
            }
        }
    }
}
