//
//  LoginScreen.swift
//  MyNotes
//
//  Created by Mauricio Chaves Dias on 26/3/2023.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject private var loginVM = LoginViewModel()
    @State private var username = ""
    @State private var password = ""
    @State private var reenterPassword = ""

    
    var body: some View {
        NavigationView {
            ZStack {
                Color.green
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
                        .bold()
                        .padding()
                    VStack {
                        if !loginVM.authentication.successfull {
                            Text(loginVM.authentication.message)
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                        
                        TextField("Username", text: $loginVM.username)
                            .padding()
                            .frame(width: 300, height:  50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .border(.red, width: loginVM.authentication.successfull ? CGFloat(0) : CGFloat(2))
                        SecureField("Password", text: $loginVM.password)
                            .padding()
                            .frame(width: 300, height:  50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .border(.red, width: loginVM.authentication.successfull ? CGFloat(0) : CGFloat(2))
                        if loginVM.showSignUpScreen {
                            SecureField("Re-enter Password", text: $loginVM.reenterPassword)
                                .padding()
                                .frame(width: 300, height:  50)
                                .background(Color.black.opacity(0.05))
                                .cornerRadius(10)
                                .border(.red, width: loginVM.authentication.successfull ? CGFloat(0) : CGFloat(2))
                        }

                        Button(loginVM.showSignUpScreen ? "Create" : "Login") {
                            if loginVM.showSignUpScreen {
                                //TODO: create new user
                               // loginVM.createNewUser()
                                loginVM.createButtonTapped()
                            } else {
                                //TODO: Authenticate user
                                loginVM.loginButtonTapped()
                               // loginVM.authenticateLogin()
                                //authenticateUser(username: username, password: password)
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
                            Text("You are logged in")
                                .navigationBarBackButtonHidden(true)
                                .navigationBarHidden(true)
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
    }
}

