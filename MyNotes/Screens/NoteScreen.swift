//
//  NoteScreen.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 28/3/2023.
//

import SwiftUI

struct NoteScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var addNoteVM = AddNoteViewModel()
    @State private var presentsDeleteDialog: Bool = false
    
    @State var note: NoteViewModel
    @State private var title: String = ""
    @State private var text: String = ""
    
    @FocusState private var focusedField: Fields?
    
    private enum Fields: Hashable {
        case title
        //in case there is more fields to focus on the screen add here
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
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
                            addNoteVM.editNote(note: note)
                            dismiss()
                        }
                        Spacer()
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button(role: .destructive) {
                            presentsDeleteDialog = true
                        } label: {
                            Label("", systemImage: "trash")
                                .foregroundColor(.red.opacity(0.5))
                        }
                        .confirmationDialog("Are you sure?",
                                            isPresented: $presentsDeleteDialog) {
                            Button("Delete", role: .destructive) {
                                //TODO: Delete note
                                addNoteVM.deleteNote(note: note)
                                dismiss()
                            }
                        }

                    }
                }
                .navigationTitle("Edit Note")
                .onAppear {
                    addNoteVM.loadNote(note: note)
                }
            }
            
            Spacer()
        }
    }
}

struct NoteScreen_Previews: PreviewProvider {
    static var previews: some View {
        NoteScreen(note: NoteViewModel(note: Note(context: CoreDataManager.shared.viewContext)))
    }
}
