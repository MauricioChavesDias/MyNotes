//
//  AddNoteViewModel.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 27/3/2023.
//

import Foundation

class AddNoteViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var text: String = ""
    @Published var dismissAddNoteScreen: Bool = false
    
    func addNewNote(user: UserViewModel?) {
        if let currentUser = user {
            let saveUser = User.getUserByID(id: currentUser.id)
            let note = Note(context: CoreDataManager.shared.viewContext)
            note.user = saveUser
            note.title = title.isEmpty ? "No Title" : title
            note.text = text.isEmpty ? "No Description" : text
            
            note.save()
            resetUI()
            dismissScreen()
        }
    }
    
    func editNote(note: NoteViewModel?) {
        if let safeNote = note {
            if let foundNote = Note.getNoteByID(id: safeNote.noteId) {
                foundNote.title = title.isEmpty ? "No Title" : title
                foundNote.text = text.isEmpty ? "No Description" : text
                foundNote.save()
                dismissScreen()
            }
        }
    }
    
    func deleteNote(note: NoteViewModel?) {
        if let safeNote = note {
            if let foundNote = Note.getNoteByID(id: safeNote.noteId) {
                foundNote.delete()
            }
        }
    }
    
    func loadNote(note: NoteViewModel?) {
        if let safeNote = note {
            if let foundNote = Note.getNoteByID(id: safeNote.noteId) {
                title = foundNote.title ?? ""
                text = foundNote.text ?? ""
            }
        }
    }
    
    private func dismissScreen() {
        dismissAddNoteScreen.toggle()
    }
    
    private func resetUI() {
        title = ""
        text = ""
    }
}
