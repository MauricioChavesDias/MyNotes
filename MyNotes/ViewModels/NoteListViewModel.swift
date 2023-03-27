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
        return note.text ?? "No Title"
    }
    
    var text: String {
        return note.text ?? ""
    }
}

class NoteListViewModel: ObservableObject {
    
    @Published var notes = [NoteViewModel]()
    
    func getNotesByUser(userAccountVM: UserAccountViewModel) {
        
        if let currentUserAccount = userAccountVM.currentUserAccount {
            if let user = CoreDataManager.shared.getUserByID(id: currentUserAccount.id) {
                DispatchQueue.main.async {
                    self.notes = (user.notes?.allObjects as! [Note]).map(NoteViewModel.init)
                }
            }
        }
    }
}


