//
//  NoteListScreen.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 27/3/2023.
//

import SwiftUI

struct NoteListScreen: View {
    @State private var showAddNoteScreen: Bool = false
    @StateObject private var noteListViewModel = NoteListViewModel()
    
    let currentUser: UserViewModel?
    
    var body: some View {
        HStack {
            List {
                ForEach(noteListViewModel.notes, id: \.noteId) { note in
                    //Navigation to the edit a note
                    NavigationLink {
                      NoteScreen(note: note)
                        
                    } label: {
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                .bold()
                                .autocorrectionDisabled()
                                .lineLimit(1)
                            Text(note.text)
                                .font(.footnote)
                                .autocorrectionDisabled()
                                .lineLimit(1)
                        }
                    }
                }
                .onDelete(perform : deleteNotes)
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .accessibilityIdentifier("editButton")
                }
                ToolbarItem {
                    Button {
                        noteListViewModel.addNoteButtonTapped()
                    } label: {
                        Label("Add Note", systemImage: "plus")
                    }
                    .accessibilityIdentifier("addNoteButton")
                }
            }
            .sheet(isPresented: $noteListViewModel.showAddNoteScreen) {
                AddNoteScreen(showView: $noteListViewModel.showAddNoteScreen, currentUser: currentUser)
                    .onDisappear{
                        noteListViewModel.loadAllNotesByUser(user: currentUser)
                    }
            }
            .onAppear {
                noteListViewModel.loadAllNotesByUser(user: currentUser)
            }
            .accessibilityIdentifier("navigationNotesList")
            .embedInNavigationView()

        }
    }
    
    private func deleteNotes(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                let note = noteListViewModel.notes[index]
                noteListViewModel.delete(note)
            }
        }
        noteListViewModel.loadAllNotesByUser(user: currentUser)
    }
}

struct NoteListScreen_Previews: PreviewProvider {
    static var previews: some View {
        let previewCurrentUser = UserViewModel(user: User(context: CoreDataManager.shared.persistentContainer.viewContext))
        NoteListScreen(currentUser: previewCurrentUser)
    }
}
