//
//  AddNoteViewModel.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 27/3/2023.
//

import Foundation

class AddNoteViewModel: ObservableObject {
    
    var title: String = ""
    var text: String = ""
    
    func addNoteForUser(vm: UserAccountViewModel) {
        
        if let accountInUse = vm.currentUserAccount {
            let user = CoreDataManager.shared.getUserByID(id: accountInUse.id)
            let note = Note(context: CoreDataManager.shared.persistentContainer.viewContext)
            note.user = user
            note.title = title
            note.text = text
            
            CoreDataManager.shared.saveInCoreData()
        }
        

        
    }
}
