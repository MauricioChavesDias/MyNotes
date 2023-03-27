//
//  AuthenticateAccountViewModel.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 27/3/2023.
//

import Foundation
import CoreData

struct UserViewModel {
    
    let user: User
    
    var id: NSManagedObjectID {
        return user.objectID
    }
    
    var username: String {
        return user.username ?? ""
    }
    
    var password: String {
        return user.password ?? ""
    }
}

class UserAccountViewModel: ObservableObject {
    var currentUserAccount: UserViewModel?
    @Published var userAccounts = [UserViewModel]()
    @Published var username = ""
    @Published var password = ""
    
    func addNewUserAccount() {
        if !username.isEmpty && !password.isEmpty {
            let manager = CoreDataManager.shared
            let account = User(context: manager.persistentContainer.viewContext)
            account.username = username
            account.password = password
            
            manager.saveInCoreData()
        }
    }
    
    func loadAllUserAccounts() {
        if userAccounts.count > 0 {
            userAccounts.removeAll()
        }
        let users = CoreDataManager.shared.getAllUserAccounts()
        self.userAccounts = users.map(UserViewModel.init)
    }
    
    func checkExistingUserAccount(from user: UserViewModel) -> UserViewModel? {
        let user = userAccounts.filter { $0.username == user.username && $0.password == user.password }
        if user.count > 0 {
            return user[0]
        } else {
            return nil
        }
    }
    
    func updateCurrentUserAccount(with user: UserViewModel?) {
        if let accountInUse = user {
            currentUserAccount = accountInUse
        }
    }
    
}

