//
//  AccountListingViewModel.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2025-01-22.
//

import Foundation
import GRDB
import Combine
import Swinject

public class AccountListingViewModel: ObservableObject {
    let accountDao: AccountDao
    @Published var currentAccount: Account
    @Published var otherAccounts: [Account] = []
    
    public init(dbPool: DatabasePool) {
        self.accountDao = AccountDao(dbPool: dbPool)
        
        do {
            let accounts = try accountDao.getAllAccounts()
            if let currentAccount = try accountDao.getCurrentAccount() {
                self.currentAccount = currentAccount
                self.otherAccounts = try accountDao.getAllNonCurrentAccounts()
            } else {
                self.currentAccount = Account.ANONYMOUS_ACCOUNT
                self.otherAccounts = try accountDao.getAllNonCurrentAccounts()
            }
        } catch {
            print("Error fetching accounts: \(error)")
            self.currentAccount = Account.ANONYMOUS_ACCOUNT
        }
    }
}
