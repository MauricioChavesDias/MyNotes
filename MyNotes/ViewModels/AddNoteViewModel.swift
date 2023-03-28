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
            note.title = title
            note.text = text
            
            note.save()
            resetUI()
            dismissScreen()
        }
    }
    
    private func dismissScreen() {
        dismissAddNoteScreen.toggle()
    }
    
    private func resetUI() {
        title = ""
        text = ""
    }
    
//    func addNoteForUser(vm: UserAccountViewModel) {
//        
//        if let accountInUse = vm.currentUserAccount {
//            let user = CoreDataManager.shared.getUserByID(id: accountInUse.id)
//            let note = Note(context: CoreDataManager.shared.persistentContainer.viewContext)
//            note.user = user
//            note.title = title
//            note.text = text
//            
//            CoreDataManager.shared.saveInCoreData()
//        }
//    }
}
