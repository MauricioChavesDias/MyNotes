//
//  NoteListViewModelTests.swift
//  MyNotesTests
//
//  Created by Mauricio Chaves Dias on 29/3/2023.
//

import XCTest
@testable import MyNotes

final class NoteListViewModelTests: XCTestCase {
    
    func test_AddNoteButtonTapped() {
        let viewModel = NoteListViewModel()
        viewModel.addNoteButtonTapped()
        XCTAssertTrue(viewModel.showAddNoteScreen)
    }
    
    func test_LoadAllNotesByUser() {
        let viewModel = NoteListViewModel()
        let dummyUser = User(context: CoreDataManager.shared.viewContext)
        dummyUser.username = "unittest"
        dummyUser.password = "1234"
        dummyUser.save()
        let userViewModel = UserViewModel(user: dummyUser)
        viewModel.loadAllNotesByUser(user: userViewModel)
        XCTAssertEqual(viewModel.notes.count, 0) // Initially, the notes array should be empty.
        let note = Note(context: CoreDataManager.shared.viewContext)
        note.user = dummyUser
        note.title = "Note 1"
        note.text = "description"
        note.save()
        viewModel.notes = [NoteViewModel(note: note)]
        viewModel.loadAllNotesByUser(user: userViewModel)
        XCTAssertEqual(viewModel.notes.count, 1) // After loading the notes, the count should be 1.
        dummyUser.delete()
    }
    
    func test_Delete() {
        let dummyUser = User(context: CoreDataManager.shared.viewContext)
        dummyUser.username = "unittest"
        dummyUser.password = "1234"
        dummyUser.save()
        let dummyNote = Note(context: CoreDataManager.shared.viewContext)
        dummyNote.user = dummyUser
        dummyNote.title = "Note 1"
        dummyNote.text = "description"
        dummyNote.save()
        let viewModel = NoteListViewModel()
        let note = NoteViewModel(note: dummyNote)
        viewModel.notes = [note]
        viewModel.delete(note)
        XCTAssertEqual(viewModel.notes.count, 0) // After deleting the note, the count should be 0.
    }
}
