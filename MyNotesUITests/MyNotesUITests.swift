//
//  MyNotesUITests.swift
//  MyNotesUITests
//
//  Created by Mauricio Chaves Dias on 26/3/2023.
//

import XCTest
@testable import MyNotes

final class MyNotesUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    let dummyUsername = "UITestForWhenUserHasBeenCreatedAlready5"
    let dummyPassword = "123"
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func isKeyboardShown() -> Bool {
        return XCUIApplication().keyboards.keys.count > 0
    }
    
    /// WORKFLOW OF THE APP TESTING EVERYTHING
    func test_User_Login_SignUP_Flow(){
        login_screen()
        //validating_login_throught_the_signUp()
        //signUP_screen()
        login_successfull()
        notes_screen_after_successfull_login()
        add_Note(title: "My first  note")
    }
    
    private func signUP_screen() {
        let createdAccount = checkIfUserCreationSucceed(username: dummyUsername, password: dummyPassword)

        XCTAssert(createdAccount)
    }
    
    private func validating_login_throught_the_signUp() {
        // When the there is an error in these credentials we need to force go back to the login page tapping cancel button
        XCTAssertTrue(!validatesLoginCredentialsToTestSpecialCharacters(username: "john01", password: "Ab01@1"))
        app.buttons["signUpOrCancelButton"].tap()
        XCTAssertTrue(!validatesLoginCredentialsToTestSpecialCharacters(username: "nikita", password: "ZoPW_98"))
        app.buttons["signUpOrCancelButton"].tap()
        
        XCTAssertTrue(validatesLoginCredentialsToTestSpecialCharacters(username: "mike_", password: "20Mike"))
        XCTAssertTrue(validatesLoginCredentialsToTestSpecialCharacters(username: "test", password: "test2@"))
    }
    
    private func createNewUser(username: String, password: String) {
        // Tap the SignUp button
        self.app.buttons["signUpOrCancelButton"].tap()

        // Get the username and password fields
        let usernameTextField = app.textFields["usernameTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let rePasswordTextField = app.secureTextFields["rePasswordTextField"]

        // Enter the username and password
        usernameTextField.tap()
        if isKeyboardShown() {
            usernameTextField.typeText(username)
        }
        passwordTextField.tap()
        if isKeyboardShown() {
            passwordTextField.typeText(password)
        }
        rePasswordTextField.tap()
        if isKeyboardShown() {
            rePasswordTextField.typeText(password)
        }

        // Tap the Create button
        app.buttons["loginOrCreateButton"].tap()
    }
    
    private func checkIfUserCreationSucceed(username: String, password: String) -> Bool {
        createNewUser(username: username, password: password)

        // Checks if the creation has succeeded.
        let loggedInLabel = app.staticTexts["messageStatus"]
        let description = loggedInLabel.label
        var createdAccountSuccessfully = description == "User successfully created!"
        if !createdAccountSuccessfully {
            if description == "Username already taken. Please, choose another one." {
                createdAccountSuccessfully = true
                // Tap the cancel button to return to the login screen if already signed up this account
                app.buttons["signUpOrCancelButton"].tap() //ATTENTION: this is also used as a cancel button
            }
        }
        return createdAccountSuccessfully
    }
    
    private func validatesLoginCredentialsToTestSpecialCharacters(username: String, password: String) -> Bool {
        let successfullyCreatedUser = checkIfUserCreationSucceed(username: username, password: password)
        return successfullyCreatedUser
        
    }
    
    private func login_screen() {
        XCTAssertTrue(app.textFields["usernameTextField"].exists)
        XCTAssertTrue(app.secureTextFields["passwordTextField"].exists)
        XCTAssertTrue(app.buttons["loginOrCreateButton"].exists)
        XCTAssertTrue(app.buttons["signUpOrCancelButton"].exists)
    }
    
    private func login_successfull(){
        // Get the username and password fields
        let usernameTextField = app.textFields["usernameTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]

        // Enter the username and password
        usernameTextField.tap()
        if isKeyboardShown() {
            usernameTextField.typeText(dummyUsername)
        }
        passwordTextField.tap()
        if isKeyboardShown() {
            passwordTextField.typeText(dummyPassword)
        }

        // Tap the Login button
        app.buttons["loginOrCreateButton"].tap()

        // Check if the user is logged in
        let messageStatus = app.staticTexts["messageStatus"].label
        let successfullyLoggedIn = messageStatus == "You've successfully logged in!"

        XCTAssertTrue(successfullyLoggedIn)
    }
    
    private func validating_login_through_signUP(){
        let validatedCreationUsers =  !checkIfUserCreationSucceed(username: "john01", password: "Ab01@1") &&
                                       checkIfUserCreationSucceed(username: "mike_", password: "20Mike")  &&
                                      !checkIfUserCreationSucceed(username: "nikita", password: "ZoPW_98") &&
                                       checkIfUserCreationSucceed(username: "test", password: "test2@")
  
        XCTAssertTrue(validatedCreationUsers)
    }
    
    private func add_Note(title: String) {
        //When tapping the add note
        app.buttons["addNoteButton"].tap()
        
        //Given a new title
        let titleTextField = app.textFields["Title"]
        titleTextField.tap()
        if isKeyboardShown() {
            titleTextField.typeText(title)
        }
        //It should save a new note
        app.buttons["Save"].tap()
    }
    
    private func notes_screen_after_successfull_login(){
        let navBar = app.navigationBars["Notes"].waitForExistence(timeout: 2)
        XCTAssertTrue(navBar)
        let addButton = self.app.buttons["addNoteButton"]
        XCTAssertTrue(addButton.exists)
        let editButton = self.app.buttons["editButton"]
        XCTAssertTrue(editButton.exists)
    }
    
}
