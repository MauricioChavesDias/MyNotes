//
//  CoreDataManager.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 26/3/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MyNotes")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to initialise Core Data \(error.localizedDescription)")
            }
        }
    }
    
    func saveNewUser() {
        do {
            try persistentContainer.viewContext.save()
            print("New user has been saved in the database!")
        } catch  {
            print("Failed to save new user to the database \(error.localizedDescription)")
        }
    }
   
    func getUser(username: String, password: String) -> [User] {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch  {
            print("Unable to find the user in the database \(error.localizedDescription)")
            return []
        }
    }
    
}
