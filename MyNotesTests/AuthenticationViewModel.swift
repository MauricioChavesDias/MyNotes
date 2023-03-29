//
//  AuthenticationViewModel.swift
//  MyNotesTests
//
//  Created by Mauricio Chaves Dias on 29/3/2023.
//

import XCTest
@testable import MyNotes

final class AuthenticationViewModelTests: XCTestCase {
    func testCreateNewUserSuccess() {
        let viewModel = AuthenticationViewModel()
        viewModel.username = "john"
        viewModel.password = "password"
        viewModel.reenterPassword = "password"
        if let userViewModel = viewModel.userAccountViewModel.checkingExistingUserAccountBy(username: viewModel.username,
                                                                                            password: viewModel.password) {
            let userID = userViewModel.id
            let user = User.getUserByID(id: userID)
            user?.delete()
        }
        viewModel.createNewUser()
        XCTAssertTrue(viewModel.authentication.successfull)
        XCTAssertEqual(viewModel.authentication.message, "User successfully created!")
    }
    
    func testCreateNewUserUsernameTaken() {
        let viewModel = AuthenticationViewModel()
        viewModel.username = "john"
        viewModel.password = "password"
        viewModel.reenterPassword = "password"
        viewModel.createNewUser()
        XCTAssertFalse(viewModel.authentication.successfull)
        XCTAssertEqual(viewModel.authentication.message, "Username already taken. Please, choose another one.")
    }
    
    func testCreateNewUserInvalidUsername() {
        let viewModel = AuthenticationViewModel()
        viewModel.username = "jo"
        viewModel.password = "password"
        viewModel.reenterPassword = "password"
        viewModel.createNewUser()
        XCTAssertFalse(viewModel.authentication.successfull)
        XCTAssertEqual(viewModel.authentication.message, "Username should be longer than 3 characters.")
    }
    
    func testCreateNewUserInvalidPassword() {
        let viewModel = AuthenticationViewModel()
        viewModel.username = "john"
        viewModel.password = "pw"
        viewModel.reenterPassword = "pw"
        viewModel.createNewUser()
        XCTAssertFalse(viewModel.authentication.successfull)
        XCTAssertEqual(viewModel.authentication.message, "Password should be longer than 3 characteres.")
    }
    
    func testLoginSuccess() {
        let viewModel = AuthenticationViewModel()
        viewModel.username = "john"
        viewModel.password = "password"
        viewModel.loginButtonTapped()
        XCTAssertTrue(viewModel.authentication.successfull)
        XCTAssertEqual(viewModel.authentication.message, "You've successfully logged in!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(viewModel.showNotesScreen)
        }
    }
    
    func testLoginInvalidUsername() {
        let viewModel = AuthenticationViewModel()
        viewModel.username = "jo"
        viewModel.password = "password"
        viewModel.loginButtonTapped()
        XCTAssertFalse(viewModel.authentication.successfull)
        XCTAssertEqual(viewModel.authentication.message, "Invalid username.")
        XCTAssertFalse(viewModel.showNotesScreen)
    }
    
    func testLoginInvalidPassword() {
        let viewModel = AuthenticationViewModel()
        viewModel.username = "john"
        viewModel.password = "pw"
        viewModel.loginButtonTapped()
        XCTAssertFalse(viewModel.authentication.successfull)
        XCTAssertEqual(viewModel.authentication.message, "Invalid password.")
        XCTAssertFalse(viewModel.showNotesScreen)
    }
    
    func testLoginUserDoesNotExist() {
        let viewModel = AuthenticationViewModel()
        viewModel.username = "nonexistentuser"
        viewModel.password = "password"
        viewModel.loginButtonTapped()
        XCTAssertFalse(viewModel.authentication.successfull)
        XCTAssertEqual(viewModel.authentication.message, "Please try a different username or password")
        XCTAssertFalse(viewModel.showNotesScreen)
    }
}
