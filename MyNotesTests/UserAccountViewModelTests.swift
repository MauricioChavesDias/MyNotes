//
//  UserAccountViewModelTests.swift
//  MyNotesTests
//
//  Created by Mauricio Chaves Dias on 29/3/2023.
//

import XCTest
@testable import MyNotes

final class UserAccountViewModelTests: XCTestCase {
    
    var userAccountViewModel: UserAccountViewModel!

    override func setUp() {
        super.setUp()
        userAccountViewModel = UserAccountViewModel()
    }

    override func tearDown() {
        super.tearDown()
        userAccountViewModel = nil
    }

    func testAddNewUserAccount() {
        // Given
        userAccountViewModel.username = "testUser"
        userAccountViewModel.password = "testPassword"

        // When
        userAccountViewModel.addNewUserAccount()

        // Then
        let existingUserAccount = userAccountViewModel.checkingExistingUserAccountBy(username: userAccountViewModel.username,
                                                                                     password: userAccountViewModel.password)
        XCTAssertNotNil(existingUserAccount)
        XCTAssertEqual(existingUserAccount?.username, userAccountViewModel.username)
        XCTAssertEqual(existingUserAccount?.password, userAccountViewModel.password)
    }

    func testLoadAllUserAccounts() {
        // Given
        let user1 = User(context: CoreDataManager.shared.viewContext)
        user1.username = "user1"
        user1.password = "password1"
        user1.save()
        let user2 = User(context: CoreDataManager.shared.viewContext)
        user2.username = "user2"
        user2.password = "password2"
        user2.save()
  
       

        // When
        userAccountViewModel.loadAllUserAccounts()

        // Then
        XCTAssertEqual(userAccountViewModel.userAccounts.count > 1, true)
        
        user1.delete()
        user2.delete()
    }

    func testCheckExistingUserAccount() {
        // Given
        let user1 = User(context: CoreDataManager.shared.viewContext)
        user1.username = "unittestExisting"
        user1.password = "password1"
        user1.save()
        
        let user2 = User(context: CoreDataManager.shared.viewContext)
        user2.username = "unittestExisting2"
        user2.password = "password2"
        user2.save()

        let user1ViewModel = UserViewModel(user: user1)
        let user2ViewModel = UserViewModel(user: user2)

        // When
        let existingUser1ViewModel = userAccountViewModel.checkingExistingUserAccountBy(username: user1ViewModel.username,
                                                                                        password: user1ViewModel.password)
        let existingUser2ViewModel = userAccountViewModel.checkingExistingUserAccountBy(username: user2ViewModel.username,
                                                                                        password: user2ViewModel.password)
        let nonExistingUserViewModel = userAccountViewModel.checkingExistingUserAccountBy(username: "unitunitunittestdummy",
                                                                                        password: "unitunitunittestdummy")

        // Then
        XCTAssertNotNil(existingUser1ViewModel)
        XCTAssertEqual(existingUser1ViewModel?.username, user1.username)
        XCTAssertEqual(existingUser1ViewModel?.password, user1.password)

        XCTAssertNotNil(existingUser2ViewModel)
        XCTAssertEqual(existingUser2ViewModel?.username, user2.username)
        XCTAssertEqual(existingUser2ViewModel?.password, user2.password)

        XCTAssertNil(nonExistingUserViewModel)
        
        user1.delete()
        user2.delete()
    }
}
