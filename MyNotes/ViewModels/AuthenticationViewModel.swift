//
//  LoginViewModel.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 26/3/2023.
//

import Foundation
import CoreData

struct Authentication {
    var successfull: Bool
    var message: String
}

class AuthenticationViewModel: ObservableObject {
    @Published var userAccountViewModel = UserAccountViewModel()
    @Published var authentication = Authentication(successfull: true, message: "")
    @Published var username = ""
    @Published var password = ""
    @Published var reenterPassword = ""
    @Published var showLoginScreen = false
    @Published var showSignUpScreen = false
    @Published var showNotesScreen = false
    
    var currentUserAccount: UserViewModel?

    func createButtonTapped() {
        authentication.message = ""
        createNewUser()
    }
    
    func signedUpButtonTapped() {
        authentication.successfull = true
        authentication.message = ""
        resetUI()
        toggleToShowSignUpButtons()
    }
    
    func cancelButtonTapped() {
        authentication.successfull = true
        authentication.message = ""
        resetUI()
        toggleToShowLoginButtons()
    }
    
    func loginButtonTapped() {
        login()
    }
    
    private func login() {
        userAccountViewModel.loadAllUserAccounts()
        print(userAccountViewModel.userAccounts)
        if validateSpecialCharactersLogin() {
            if verifyUserAlreadyExists() {
                authentication.successfull = true
                authentication.message = "You've successfully logged in!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.showNotesScreen = true
                }
            } else {
                authentication.successfull = false
                authentication.message = "Please try a different username or password"
            }
        }
    }
    
    private func createNewUser() {
        if validateSpecialCharactersNewUser() {
            if !verifyUserAlreadyExists() {
                userAccountViewModel.username = username.lowercased()
                userAccountViewModel.password = password.lowercased()
                userAccountViewModel.addNewUserAccount()
                authentication.successfull = true
                authentication.message = "User successfully created!"
                resetUI()
                toggleToShowLoginButtons()
            } else {
                authentication.successfull = false
                authentication.message = "Username already taken. Please, choose another one."
            }
        }
    }

    private func verifyUserAlreadyExists() -> Bool {
        userAccountViewModel.loadAllUserAccounts()
        let accounts = userAccountViewModel.userAccounts
        let accountsFound = accounts.filter({ $0.username.lowercased() == username.lowercased() && $0.password.lowercased() == password.lowercased() })
        let hasAccount = accountsFound.count > 0
        if hasAccount {
            let accountInUse = accountsFound.first
            self.currentUserAccount = accountInUse
           // userAccountViewModel.updateCurrentUserAccount(with: firstAccount)
        }
        
        return hasAccount
    }
        
    private func toggleToShowSignUpButtons() {
        showSignUpScreen = true
        showLoginScreen = false
    }
    
    private func toggleToShowLoginButtons() {
        showSignUpScreen = false
        showLoginScreen = true
    }
    
    private func resetUI() {
        username = ""
        password = ""
        reenterPassword = ""
    }
    
    private func validateSpecialCharactersNewUser() -> Bool {
        if username.isEmpty {
            authentication.successfull = false
            authentication.message = "User name is empty."
        } else if username.count < 3 {
            authentication.successfull = false
            authentication.message = "Username should be longer than 3 characters."
        } else if verifySpecialCharacters(for: username) {
            authentication.successfull = false
            authentication.message = "Username can not contain space or special characters."
        } else if password.isEmpty {
            authentication.successfull = false
            authentication.message = "Password is empty."
        } else if password.count < 3 {
            authentication.successfull = false
            authentication.message = "Password should be longer than 3 characteres."
        } else if verifySpecialCharacters(for: password) {
            authentication.successfull = false
            authentication.message = "Password can not contain space or special characters."
        } else if reenterPassword.isEmpty {
            authentication.successfull = false
            authentication.message = "Re-enter password is empty."
        } else if password != reenterPassword {
            authentication.successfull = false
            authentication.message = "Passwords do not match."
        } else {
            authentication.successfull = true
        }
        return authentication.successfull
    }
    
    private func validateSpecialCharactersLogin() -> Bool {
        if username.isEmpty {
            authentication.successfull = false
            authentication.message = "User name is empty."
        } else if username.count < 3 {
            authentication.successfull = false
            authentication.message = "Invalid username."
        } else if password.isEmpty {
            authentication.successfull = false
            authentication.message = "Password is empty."
        } else if password.count < 3 {
            authentication.successfull = false
            authentication.message = "Invalid password."
        } else {
            authentication.successfull = true
        }
        
        return authentication.successfull
    }
    
    private func verifySpecialCharacters(for username: String) -> Bool {
        let expression = "(?<=\\w)[^a-zA-Z0-9]+(?=\\w)"
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options())
        let range = NSRange(location: 0, length: username.utf16.count)
        let containsSpecialCharsOrSpaces = regex.firstMatch(in: username, options: NSRegularExpression.MatchingOptions(), range: range) != nil || username.contains(" ")

        return containsSpecialCharsOrSpaces
    }
}
