//
//  AddNoteViewModelTests.swift
//  MyNotesTests
//
//  Created by Mauricio Chaves Dias on 29/3/2023.
//

import XCTest
@testable import MyNotes

final class AddNoteViewModelTests: XCTestCase {
    var viewModel: AddNoteViewModel!
    var userViewModel: UserViewModel!

    override func setUp() {
        super.setUp()
        viewModel = AddNoteViewModel()
        let dummyUser = User(context: CoreDataManager.shared.viewContext)
        dummyUser.username = "unittest"
        dummyUser.password = "1234"
        dummyUser.save()
        userViewModel = UserViewModel(user: dummyUser)
    }

    override func tearDown() {
        super.tearDown()
        userViewModel.user.delete()//make sure to delete dummy data from the database
        viewModel = nil
        userViewModel = nil
    }

    func testAddNewNote() {
        // Given
        viewModel.title = "Test Note"
        viewModel.text = "Test Description"
        
        // When
        viewModel.addNewNote(user: userViewModel)

        // Then
        XCTAssertEqual(Note.getNotesByUserId(userID: userViewModel.id).count, 1)
    }
    
    func testEditNote() {
        // Given
        let dummyNote = Note(context: CoreDataManager.shared.viewContext)
        dummyNote.user = userViewModel.user
        dummyNote.title = "Old Title"
        dummyNote.text =  "Old Description"
        dummyNote.save()
        let note = NoteViewModel(note: dummyNote)
        
        viewModel.title = "New Title"
        viewModel.text = "New Description"

        // When
        viewModel.editNote(note: note)

        // Then
        let updatedNote = Note.getNoteByID(id: note.noteId)!
        XCTAssertEqual(updatedNote.title, viewModel.title)
        XCTAssertEqual(updatedNote.text, viewModel.text)
    }
    
    func testDeleteNote() {
        // Given
        let dummyNote = Note(context: CoreDataManager.shared.viewContext)
        dummyNote.user = userViewModel.user
        dummyNote.title = "Note to be deleted"
        dummyNote.text =  "Description to be deleted"
        dummyNote.save()
        let note = NoteViewModel(note: dummyNote)

        // When
        viewModel.deleteNote(note: note)

        // Then
        XCTAssertNil(Note.getNoteByID(id: note.noteId))
    }
    
    func testLoadNote() {
        // Given
        let dummyNote = Note(context: CoreDataManager.shared.viewContext)
        dummyNote.user = userViewModel.user
        dummyNote.title = "Loading a note to the screen"
        dummyNote.text =  "Loading a description to the screen"
        dummyNote.save()
        let note = NoteViewModel(note: dummyNote)
        
        // When
        viewModel.loadNote(note: note)

        // Then
        XCTAssertEqual(viewModel.title, note.title)
        XCTAssertEqual(viewModel.text, note.text)
    }
}
