//
//  SendChatMessageView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-19.
//

import SwiftUI

struct SendChatMessageView: View {
    @StateObject private var sendChatMessageViewModel: SendChatMessageViewModel
    
    @FocusState private var focusedField: FieldType?
    
    init(username: String?) {
        _sendChatMessageViewModel = StateObject(wrappedValue: SendChatMessageViewModel(username: username, sendChatMessageRepository: SendChatMessageRepository()))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                CustomTextField(
                    "Username",
                    text: $sendChatMessageViewModel.username,
                    singleLine: true,
                    keyboardType: .default,
                    showBorder: false,
                    fieldType: .username,
                    focusedField: $focusedField
                )
                .padding(.horizontal, 16)
            }
        }
    }
    
    private enum FieldType: Hashable {
        case username
        case subject
        case message
    }
}
