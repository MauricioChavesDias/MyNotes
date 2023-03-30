//
//  SecuredFieldViewModifier.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 30/3/2023.
//

import SwiftUI

struct SecureFieldViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .disableAutocorrection(true)
            .foregroundColor(.black)
            .padding()
            .frame(width: 300, height:  50)
            .background(Color.black.opacity(0.05))
            .cornerRadius(10)
            .textContentType(.oneTimeCode)
    }
}
