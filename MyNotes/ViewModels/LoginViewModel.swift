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
            showNotesScreen = true
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
            
            showSignUpScreen = false
            showLoginScreen = true
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
        authentication.message = ""
        if username.isEmpty {
            authentication.successfull = false
            authentication.message = "User name is empty."
        } else if username.count < 3 {
            authentication.successfull = false
            authentication.message = "Username should be longer than 3 characters."
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
        }
        //TODO: add another condition checking if the user already exists in the database.
        
        return authentication

    }
    
    private func authenticateLogin() -> Authentication {
        authentication.successfull = true
        authentication.message = ""
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
        }
        //TODO: add another condition to check if the user exists in the database.
        
        return authentication
    }

}
