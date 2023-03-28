//
//  LoginScreen.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 26/3/2023.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject var authenticationVM = AuthenticationViewModel()
    
    @State private var username = ""
    @State private var password = ""
    @State private var reenterPassword = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.accentColor
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white.opacity(0.9))
                VStack(alignment: .center, spacing: 50) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                        .bold()
                        .padding()
                    VStack {
                        //Message - Status
                        Text(authenticationVM.authentication.message)
                            .font(.subheadline)
                            .foregroundColor(authenticationVM.authentication.successfull ? .green : .red)
                            .padding(.horizontal)
                        //Username
                        TextField("", text: $authenticationVM.username, prompt: Text("Username").foregroundColor(.black.opacity(0.2)))
                            .disableAutocorrection(true)
                            .padding()
                            .frame(width: 300, height:  50)
                            .background(Color.black.opacity(0.05))
                            .foregroundColor(Color.black)
                            .cornerRadius(10)
                            .border(.red, width: authenticationVM.authentication.successfull ? CGFloat(0) : CGFloat(2))
                        
                        //Password
                        SecureField("", text: $authenticationVM.password, prompt: Text("Password").foregroundColor(.black.opacity(0.2)))
                            .disableAutocorrection(true)
                            .padding()
                            .frame(width: 300, height:  50)
                            .background(Color.black.opacity(0.05))
                            .foregroundColor(Color.black)
                            .cornerRadius(10)
                            .border(.red, width: authenticationVM.authentication.successfull ? CGFloat(0) : CGFloat(2))
                        
                        if authenticationVM.showSignUpScreen {
                            //Re-enter Password
                            SecureField("Re-enter Password", text: $authenticationVM.reenterPassword)           .disableAutocorrection(true)
                                .padding()
                                .frame(width: 300, height:  50)
                                .background(Color.black.opacity(0.05))
                                .cornerRadius(10)
                                .border(.red, width: authenticationVM.authentication.successfull ? CGFloat(0) : CGFloat(2))
                        }
                        
                        Button(authenticationVM.showSignUpScreen ? "Create" : "Login") {
                            if authenticationVM.showSignUpScreen {
                                //Create a new user account
                                authenticationVM.createButtonTapped()
                            } else {
                                //Login to an existing user
                                authenticationVM.loginButtonTapped()
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                        
                        Button(!authenticationVM.showSignUpScreen ? "Sign up" : "Cancel") {
                            if !authenticationVM.showSignUpScreen {
                                authenticationVM.signedUpButtonTapped()
                            } else {
                                authenticationVM.cancelButtonTapped()
                            }
                        }
                        .foregroundColor(.green.opacity(0.9))
                        
                        
                        //Navigation to the Notes
                        NavigationLink(isActive: $authenticationVM.showNotesScreen) {
                            NoteListScreen(currentUser: authenticationVM.currentUserAccount)
                                .navigationBarBackButtonHidden(true)
                                .navigationBarHidden(true)
                                .environmentObject(authenticationVM)
                        } label: {
                            EmptyView()
                        }
                        
                    }
                }
            }
        }
    
        
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
            .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
    }
}

