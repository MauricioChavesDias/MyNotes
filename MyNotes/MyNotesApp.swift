//
//  MyNotesApp.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 26/3/2023.
//

import SwiftUI

@main
struct MyNotesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
