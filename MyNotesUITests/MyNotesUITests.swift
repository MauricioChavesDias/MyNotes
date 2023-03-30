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

    func test_MyNotes(){
        login_screen_workflow()
        notes_screen_workflow()
    }
    
    private func login_screen_workflow() {
        login_screen()
        validating_login_throught_the_signUp()
        signUP_screen()
        login_successfull()
        notes_screen_after_successfull_login()
    }
    
    private func notes_screen_workflow() {
        prepare_view_to_test()
        add_a_Note(title: "My first note")
        remove_a_Note(title: "My first note")
        preparing_for_multiple_adding_Notes()
        validate_multiple_added_notes()
        validade_added_notes_order(title: "Note 2", rowPosition: 1)
        preparing_for_multiple_swipe_left_delete_Notes()
    }
    
    private func signUP_screen() {
        let createdAccount = checkIfUserCreationSucceed(username: dummyUsername, password: dummyPassword)

        XCTAssert(createdAccount)
    }
    
    private func validating_login_throught_the_signUp() {
        // When the there is an error in these credentials we need to force go back to the login page tapping cancel button
        XCTAssertTrue(!validatesLoginCredentialsToTestSpecialCharacters(username: "john01", password: "Ab01@1"))
        XCTAssertTrue(app.buttons["signUpOrCancelButton"].waitForExistence(timeout: 0.5))
        app.buttons["signUpOrCancelButton"].tap()
        XCTAssertTrue(!validatesLoginCredentialsToTestSpecialCharacters(username: "nikita", password: "ZoPW_98"))
        XCTAssertTrue(app.buttons["signUpOrCancelButton"].waitForExistence(timeout: 0.5))
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
    
    private func add_a_Note(title: String) {
        //When tapping the add note
        let addButton = app.buttons["addNoteButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        addButton.tap()
        
        //Given a new title
        let titleTextField = app.textFields["Title"]// using this identifier due to a bug on xCode 14.2 not accepting customIdentifier in some views.
        titleTextField.tap()
        if isKeyboardShown() {
            titleTextField.typeText(title)
        }
        //It should save a new note
        app.buttons["Save"].tap()// using this identifier due to a bug on xCode 14.2 not accepting customIdentifier in some views.
        
        XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 1))
    }
    
    private func remove_a_Note(title: String) {
        // Open the first note
        let note = app.staticTexts[title]
        XCTAssert(note.waitForExistence(timeout: 1))
        note.tap()
        
        // Delete the note
        let trashButton = app.buttons["deleteNoteButton"]
        XCTAssert(trashButton.waitForExistence(timeout: 0.5))
        trashButton.tap()
        
        // Press the "Delete" button in the alert
        let deleteButtonAlert =  app.buttons["Delete"]
        XCTAssert(deleteButtonAlert.waitForExistence(timeout: 0.5))
        deleteButtonAlert.tap()
        XCTAssertFalse(app.staticTexts[title].waitForExistence(timeout: 1))
    }
    
    private func delete_swipe_left_a_Note(title: String){
        //First verify if the note exists
        XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 1))
        
        //Select the note
        let noteElement = app.staticTexts[title]

        // Swipe left on the note to show the delete button
        noteElement.swipeLeft(velocity: .slow)
        
        let buttonDelete = app.buttons["Delete"]
        XCTAssertTrue(buttonDelete.waitForExistence(timeout: 0.2))
                
        buttonDelete.tap()
        
        //Checks if the note still exists.
        XCTAssertFalse(app.staticTexts[title].waitForExistence(timeout: 0.5))
    }
    
    private func preparing_for_multiple_adding_Notes() {
        add_a_Note(title: "Note 1")
        add_a_Note(title: "Note 2")
        add_a_Note(title: "Note 3")
        add_a_Note(title: "Note 4")
    }
    
    private func preparing_for_multiple_swipe_left_delete_Notes(){
        delete_swipe_left_a_Note(title: "Note 1")
        delete_swipe_left_a_Note(title: "Note 2")
        delete_swipe_left_a_Note(title: "Note 4")
    }
    
    private func prepare_view_to_test()  {
        let cells = app.cells.allElementsBoundByIndex
        if !cells.isEmpty {
            // Loop through each cell and delete existing notes
            for cell in cells.reversed() {
                // Get the XCUIElement for the item in the cell
                let item = cell.staticTexts.firstMatch

               //it first needs to validate the added note before deleting
                validade_added_notes_order(title: item.label, rowPosition: nil)
                delete_swipe_left_a_Note(title: item.label)
            }
        }
        XCTAssertTrue(app.cells.allElementsBoundByIndex.isEmpty)
    }
    
    private func validate_multiple_added_notes() {
        //It should have 4 notes added
        XCTAssertTrue(app.cells.count == 4)
    }
    
    private func validade_added_notes_order(title: String, rowPosition: Int?) {
        //Checks if there is any notes added
        XCTAssertTrue(app.cells.count > 0)
        
        //Get the index from the Note 2
        let index = app.cells.allElementsBoundByIndex.firstIndex(where: { $0.staticTexts[title].exists })!
    
        //Checks if the index is actually from Note 2
        XCTAssertTrue(app.cells.allElementsBoundByIndex[index].staticTexts[title].exists)
        
        //Checks the row position of the element if passed by parameter
        guard let row = rowPosition else { return }
        XCTAssertTrue(index == row)
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
