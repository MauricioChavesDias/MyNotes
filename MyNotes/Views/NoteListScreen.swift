//
//  NoteListScreen.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 27/3/2023.
//

import SwiftUI

struct NoteListScreen: View {
    var body: some View {
        List(0...20, id: \.self) { index in
            HStack {
                VStack(alignment: .leading) {
                    Text("Review \(index)")
                }
                Spacer()
                Text("Notes Published")
            }
        }
        .navigationTitle("Notes")
        .background(Color.accentColor)
        .embedInNavigationView()
    }
}

struct NoteListScreen_Previews: PreviewProvider {
    static var previews: some View {
        NoteListScreen()
    }
}
