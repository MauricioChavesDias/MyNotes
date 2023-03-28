//
//  Extension+Note.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 27/3/2023.
//

import Foundation
import CoreData

extension Note: BaseModel {
    
    static func getNotesByUserId(userID: NSManagedObjectID) -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "user = %@", userID)
        
        do {
            return try CoreDataManager.shared.persistentContainer.viewContext.fetch(request)
        } catch  {
            print("Unable to get user by ID \(error.localizedDescription)")
            return []
        }
    }
    
    static func getNoteByID(id: NSManagedObjectID) -> Note? {
        return byId(id: id)
    }
}
