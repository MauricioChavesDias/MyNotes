//
//  NoteListViewModel.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 27/3/2023.
//

import Foundation
import CoreData

struct NoteViewModel {
    let note: Note
    
    var noteId: NSManagedObjectID {
        return note.objectID
    }
    
    var title: String {
        return note.title ?? "No Title"
    }
    
    var text: String {
        return note.text ?? "No Description"
    }
}

class NoteListViewModel: ObservableObject {
    
    @Published var notes = [NoteViewModel]()
    @Published var showAddNoteScreen: Bool = false
    
    func addNoteButtonTapped() {
        showAddNoteScreen.toggle()
    }
    
    func loadAllNotesByUser(user: UserViewModel?) {
        if let currentUser = user {
            DispatchQueue.main.async {
                self.notes = Note.getNotesByUserId(userID: currentUser.id).map(NoteViewModel.init)
            }
        }
    }
    
    func delete(_ note: NoteViewModel) {
        if let noteTobeDeleted = Note.getNoteByID(id: note.noteId) {
            noteTobeDeleted.delete()
        }
    }
}


