//
//  View+Extensions.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 27/3/2023.
//

import Foundation
import SwiftUI

extension View {
    //To easy embed Navigation views
    func embedInNavigationView() -> some View {
        NavigationView { self }
            .onAppear {
                //To change the Title color
                UINavigationBar.appearance().largeTitleTextAttributes =  [.foregroundColor: UIColor(.accentColor)]
            }
    }
}
