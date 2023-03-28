//
//  BaseModel.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 28/3/2023.
//

import Foundation
import CoreData

protocol BaseModel where Self: NSManagedObject {
    func save()
    func delete()
    static func byId<T: NSManagedObject>(id: NSManagedObjectID) -> T?
    static func all<T: NSManagedObject>() -> [T]
}

extension BaseModel {
    
    static var viewContext: NSManagedObjectContext {
        return CoreDataManager.shared.viewContext
    }
    
    func save() {
        do {
            try Self.viewContext.save()
            print("Successfully saved in the database!")
        } catch {
            print("Error trying to save data in the database \(error.localizedDescription)")
            Self.viewContext.rollback()
        }
    }
    
    func delete() {
        Self.viewContext.delete(self)
        save()
    }
    
    static func all<T>() -> [T] where T: NSManagedObject {
        
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Error trying to fetch all the data from the database \(error.localizedDescription)")
            return []
        }
    }
    
    static func byId<T>(id: NSManagedObjectID) -> T? where T: NSManagedObject {
        
        do {
            return try viewContext.existingObject(with: id) as? T
        } catch {
            print("Error trying to fetch data using ID from the database \(error.localizedDescription)")
            return nil
        }
        
    }
    
}
