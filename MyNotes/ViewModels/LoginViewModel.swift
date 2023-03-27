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

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var reenterPassword = ""
    @Published var showLoginScreen = false
    @Published var showSignUpScreen = false
    @Published var showNotesScreen = false
    @Published var authentication = Authentication(successfull: true, message: "")
    
    private var wrongUserName = 0
    private var wrongPassword = 0

    
    func createButtonTapped() {
        createNewUser()
    }
    
    func signedUpButtonTapped() {
        authentication.successfull = true
        authentication.message = ""
        toggleToShowSignUpButtons()
    }
    
    func cancelButtonTapped() {
        authentication.successfull = true
        authentication.message = ""
        toggleToShowLoginButtons()
    }
    
    func loginButtonTapped() {
       //authenticateLogin()
        login()
    }
    
    private func login() {
        let authentication = authenticateLogin()
        
        if authentication.successfull {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.showNotesScreen = true
            }
        }
    }
    
    private func createNewUser() {
        let authentication = authenticateNewUser()
        
        if authentication.successfull {
            let manager = CoreDataManager.shared
            let user = User(context: manager.persistentContainer.viewContext)
            user.username = username
            user.password = password
            
            manager.saveNewUser()
            
            username = ""
            password = ""
            reenterPassword = ""
            toggleToShowLoginButtons()
        }
    }
    
    private func toggleToShowSignUpButtons() {
        showSignUpScreen = true
        showLoginScreen = false
    }
    
    private func toggleToShowLoginButtons() {
        showSignUpScreen = false
        showLoginScreen = true
    }
    
    private func authenticateNewUser() -> Authentication {
        authentication.successfull = true
        authentication.message = "User successfully created!"
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
        } else if reenterPassword.isEmpty {
            authentication.successfull = false
            authentication.message = "Re-enter password is empty."
        } else if password != reenterPassword {
            authentication.successfull = false
            authentication.message = "Passwords do not match."
        } else if getExistingUser() != nil {
            authentication.successfull = false
            authentication.message = "Username already in use."
        }
        
        return authentication
    }
    
    private func authenticateLogin() -> Authentication {
        authentication.successfull = true
        authentication.message = "You successfully logged in!"
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
        } else if getExistingUser() == nil {
            authentication.successfull = false
            authentication.message = "Account does not exist"
        }
        
        return authentication
    }
    
    private func getExistingUser() -> User? {
        let user = CoreDataManager.shared.getUser(username: username, password: password)
        if  user.count > 0 {
            if user[0].username == username && user[0].password == password {
                return user[0]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    private func verifySpecialCharacters(for username: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9 ].*", options: NSRegularExpression.Options())
        let range = NSRange(location: 0, length: username.utf16.count)
        let containsSpecialCharsOrSpaces = regex.firstMatch(in: username, options: NSRegularExpression.MatchingOptions(), range: range) != nil || username.contains(" ")
        
        return containsSpecialCharsOrSpaces
    }

}
