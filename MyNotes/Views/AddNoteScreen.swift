//
//  AddNoteScreen.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 27/3/2023.
//

import SwiftUI

struct AddNoteScreen: View {
    
   // @StateObject private var addNote = AddNoteViewModel()
    @Environment(\.isPresented) var presentationMode
    
    @State private var title: String = ""
    @State private var text: String = ""
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Form {
                    TextField("Title", text: $title)
                    TextField("Description", text: $title)
                    HStack(alignment: .center) {
                        Spacer()
                        Button("Save") {
                            
                        }
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Note")
        .embedInNavigationView()
    }
}

struct AddNoteScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteScreen()
    }
}
