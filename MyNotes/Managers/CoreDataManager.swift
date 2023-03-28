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
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
}
