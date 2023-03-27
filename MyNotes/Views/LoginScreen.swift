//
//  LoginScreen.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 26/3/2023.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject private var loginVM = AuthenticationViewModel()
    
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
                        Text(loginVM.authentication.message)
                            .font(.subheadline)
                            .foregroundColor(loginVM.authentication.successfull ? .green : .red)
                            .padding(.horizontal)
                        //Username
                        TextField("", text: $loginVM.username, prompt: Text("Username").foregroundColor(.black.opacity(0.2)))
                            .padding()
                            .frame(width: 300, height:  50)
                            .background(Color.black.opacity(0.05))
                            .foregroundColor(Color.black)
                            .cornerRadius(10)
                            .border(.red, width: loginVM.authentication.successfull ? CGFloat(0) : CGFloat(2))
                        
                        //Password
                        SecureField("", text: $loginVM.password, prompt: Text("Password").foregroundColor(.black.opacity(0.2)))
                            .padding()
                            .frame(width: 300, height:  50)
                            .background(Color.black.opacity(0.05))
                            .foregroundColor(Color.black)
                            .cornerRadius(10)
                            .border(.red, width: loginVM.authentication.successfull ? CGFloat(0) : CGFloat(2))
                        
                        if loginVM.showSignUpScreen {
                            //Re-enter Password
                            SecureField("Re-enter Password", text: $loginVM.reenterPassword)
                                .padding()
                                .frame(width: 300, height:  50)
                                .background(Color.black.opacity(0.05))
                                .cornerRadius(10)
                                .border(.red, width: loginVM.authentication.successfull ? CGFloat(0) : CGFloat(2))
                        }

                        Button(loginVM.showSignUpScreen ? "Create" : "Login") {
                            if loginVM.showSignUpScreen {
                                //Create a new user account
                                loginVM.createButtonTapped()
                            } else {
                                //Login to an existing user
                                loginVM.loginButtonTapped()
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                        
                        Button(!loginVM.showSignUpScreen ? "Sign up" : "Cancel") {
                            if !loginVM.showSignUpScreen {
                                loginVM.signedUpButtonTapped()
                            } else {
                                loginVM.cancelButtonTapped()
                            }
                        }
                        .foregroundColor(.green.opacity(0.9))

                        //Navigation to the Notes
                        NavigationLink(isActive: $loginVM.showNotesScreen) {
                            NoteListScreen()
                                .navigationBarBackButtonHidden(true)
                                .navigationBarHidden(true)
                        } label: {
                            EmptyView()
                        }
               
                    }
                }
            }
        }
        .onAppear {
            
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}

