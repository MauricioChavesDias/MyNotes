//
//  Extension+User.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 28/3/2023.
//

import Foundation
import CoreData

extension User: BaseModel {
    
    static func getUserByID(id: NSManagedObjectID) -> User? {
        return byId(id: id)
    }
    
    static func getAllUserAccounts() -> [User] {
        return all()
    }
}
