//
//  CommentModerationSheet.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-24.
//

import SwiftUI

struct CommentModerationSheet: View {
    @Environment(\.dismiss) var dismiss
    
    let comment: Comment
    
    let onApprove: () -> Void
    let onRemove: () -> Void
    let onMarkAsSpam: () -> Void
    let onToggleLock: () -> Void
    
    var body: some View {
        SheetRootView {
            ScrollView {
                VStack(spacing: 0) {
                    Text("Moderate")
                        .primaryText()
                    
                    Spacer()
                        .frame(height: 16)
                    
                    if !comment.approved {
                        IconTextButton(startIconUrl: "checkmark.shield.fill", text: "Approve") {
                            onApprove()
                            dismiss()
                        }
                    }
                    
                    if !comment.removed {
                        IconTextButton(startIconUrl: "xmark", text: "Remove") {
                            onRemove()
                            dismiss()
                        }
                        
                        IconTextButton(startIconUrl: "trash", text: "Mark as spam") {
                            onMarkAsSpam()
                            dismiss()
                        }
                    }
                    
                    IconTextButton(startIconUrl: comment.locked ? "lock.open.fill" : "lock.fill", text: comment.locked ? "Unlock" : "Lock") {
                        onToggleLock()
                        dismiss()
                    }
                }
                .padding(.top, 24)
            }
        }
    }
}
