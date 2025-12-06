//
// SecuritySettingsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import SwiftUI
import Swinject
import GRDB
import LocalAuthentication

struct SecuritySettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage(SecurityUserDefaultsUtils.appLockKey, store: .security) private var appLock: Bool = false
    @AppStorage(SecurityUserDefaultsUtils.appLockTimeoutKey, store: .security) private var appLockTimeout: Int = 600000
    
    @State private var authentificated: Bool = false
    
    var body: some View {
        RootView {
            List {
                TogglePreference(isEnabled: $appLock, title: "App Lock")
                    .listPlainItemNoInsets()
                
                BarebonePickerPreference(
                    selected: $appLockTimeout,
                    items: SecurityUserDefaultsUtils.appLockTimeouts,
                    title: "App Lock Timeout"
                ) { timeout in
                    SecurityUserDefaultsUtils.appLockTimeoutsText[SecurityUserDefaultsUtils.appLockTimeouts.firstIndex(of: timeout) ?? 4]
                }
                .listPlainItemNoInsets()
            }
            .themedList()
            .onAppear {
                authenticate()
            }
            .onChange(of: authentificated) { _, newValue in
                if newValue {
                    dismiss()
                }
            }
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Security")
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We use Face ID to confirm it’s you before entering security settings."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                authentificated = !success
            }
        }
    }
}
