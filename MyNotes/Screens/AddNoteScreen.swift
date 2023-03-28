//
//  AddNoteScreen.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 27/3/2023.
//

import SwiftUI

struct AddNoteScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var addNoteVM = AddNoteViewModel()
    
    @Binding var showView: Bool
    
    @State private var title: String = ""
    @State private var text: String = ""
    
    @FocusState private var focusedField: Fields?
    
    private enum Fields: Hashable {
        case title
        //in case there is more fields to focus on the screen add here
    }
    
    var currentUser: UserViewModel?
    
    var body: some View {
        VStack(alignment: .center) {
            Form {
                TextField("Title", text: $addNoteVM.title)
                    .font(.headline.bold())
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .title)
                TextField("Description", text: $addNoteVM.text)
                    .disableAutocorrection(true)
                HStack(alignment: .center) {
                    Spacer()
                    Button("Save") {
                        addNoteVM.addNewNote(user: currentUser)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
        .navigationTitle("Note")
        .embedInNavigationView()
    }
}

struct AddNoteScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteScreen(showView: .constant(true))
    }
}
