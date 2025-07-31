//
//  InboxConversationView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-21.
//

import SwiftUI

struct InboxConversationView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var navigationBarMenuManager: NavigationBarMenuManager
    @EnvironmentObject var accountViewModel: AccountViewModel
    
    @StateObject var inboxConversationViewModel: InboxConversationViewModel
    
    @State private var scrollToBottomTrigger: Bool = false
    @State private var messageText: String = ""
    @State private var sendMessageTask: Task<Void, Never>?
    @State private var navigationBarMenuKey: UUID?
    @FocusState private var isInputActive: Bool
    
    init(inbox: Inbox) {
        _inboxConversationViewModel = StateObject(
            wrappedValue: InboxConversationViewModel(
                inbox: inbox,
                inboxConversationRepository: InboxConversationRepository()
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                List {
                    let conversations = inboxConversationViewModel.conversations
                    
                    ForEach(Array(conversations.enumerated()), id: \.element.id) { index, inbox in
                        // Remember the conversations is reversed.
                        let isLastFromSender = index == 0 || conversations[index - 1].author != inbox.author
                        
                        ChatBubble(isSentMessage: inbox.author == accountViewModel.account.username, shouldShowTail: isLastFromSender) {
                            Text(inbox.body)
                        }
                        .listPlainItemNoInsets()
                        .rotationEffect(.degrees(180))
                        .id(inbox.id)
                    }
                }
                .rotationEffect(.degrees(180))
                .themedList()
                .scrollIndicators(.hidden)
                .onTapGesture {
                    isInputActive = false
                }
                .onChange(of: inboxConversationViewModel.listScrollTarget) {
                    guard let target = inboxConversationViewModel.listScrollTarget else { return }
                    
                    proxy.scrollTo(target, anchor: .bottom)
                }
            }
            
            if inboxConversationViewModel.fullNameToReplyTo != nil {
                // It shouldn't happen but still
                HStack(spacing: 8) {
                    TextField("Type a message...", text: $messageText)
                        .focused($isInputActive)
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .submitLabel(.send)
                        .onSubmit {
                            guard sendMessageTask == nil else {
                                print("A message is being sent")
                                return
                            }
                            
                            sendMessageTask = Task {
                                defer {
                                    sendMessageTask = nil
                                }
                                
                                await inboxConversationViewModel.sendMessage(message: messageText)
                            }
                        }

                    Button(action: {
                        guard sendMessageTask == nil else {
                            print("A message is being sent")
                            return
                        }
                        
                        sendMessageTask = Task {
                            defer {
                                sendMessageTask = nil
                            }
                            
                            await inboxConversationViewModel.sendMessage(message: messageText)
                        }
                    }) {
                        SwiftUI.Image(systemName: "paperplane.fill")
                            .foregroundColor(messageText.isEmpty ? .gray : .blue)
                            .padding(10)
                    }
                    .disabled(messageText.isEmpty || sendMessageTask != nil)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(UIColor.systemBackground))
            }
        }
        .themedNavigationBar()
        .applyIf(inboxConversationViewModel.recepient != nil) {
            $0.addTitleToInlineNavigationBar(inboxConversationViewModel.recepient!)
        }
        .toolbar {
            NavigationBarMenu()
        }
        .onAppear {
            if let key = navigationBarMenuKey {
                navigationBarMenuManager.pop(key: key)
            }
            navigationBarMenuKey = navigationBarMenuManager.push([
                NavigationBarMenuItem(title: "View Profile") {
                    guard let recepient = inboxConversationViewModel.recepient else {
                        return
                    }
                    navigationManager.path.append(AppNavigation.userDetails(username: recepient))
                }
            ])
        }
        .onDisappear {
            guard let navigationBarMenuKey else { return }
            navigationBarMenuManager.pop(key: navigationBarMenuKey)
        }
    }
}

struct InboxConversationMe: View {
    var body: some View {
        EmptyView()
    }
}

struct InboxConversationThem: View {
    var body: some View {
        EmptyView()
    }
}
