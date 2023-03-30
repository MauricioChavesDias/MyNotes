//
//  TextFieldViewModifier.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 30/3/2023.
//

import SwiftUI

struct TextFieldViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .disableAutocorrection(true)
            .padding()
            .frame(width: 300, height:  50)
            .background(Color.black.opacity(0.05))
            .cornerRadius(10)
    }
}
