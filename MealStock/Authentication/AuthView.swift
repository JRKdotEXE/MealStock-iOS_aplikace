//
//  AuthView.swift
//  MealStock_koncept-v1
//
//  Created by Jiří on 05.05.2024.
//
import SwiftUI
import FirebaseFirestore

struct AuthView: View {
    @EnvironmentObject private var appController: AppController
    @State private var isSignedUp = false
    
    @State private var displayLoginScreen: Bool = true
    
    @State private var somethingWrong = false
    @State private var isEmailValid = true
    @State private var isPasswordValid = true
    @State private var authError: String? = nil

    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    
    @State var username: String = ""

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidUsername(_ username: String) -> Bool {
        return username.count >= 3 && !username.contains(" ") && !username.isEmpty 
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    var body: some View {
        VStack() {
            Spacer()
            Text("Welcome")
                .font(Font.custom("Arial", size: 57).weight(.heavy))
                .foregroundStyle(Color("darkgreen"))
                .animation(.default, value: isSignedUp)
                .padding(.vertical, 5)

            Image("Logo")
                .frame(width: 150, height: 115)
                .animation(.default, value: isSignedUp)
                .padding(.vertical)
            
            if isSignedUp {
                TextField("Username", text: $username)
                    .submitLabel(.done)
                    .padding()
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 8))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .animation(.default, value: isSignedUp)
                    .padding(.vertical, 5)
            }

            TextField("E-mail", text: $appController.email)
                .submitLabel(.done)
                .padding(20)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 8))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .animation(.default, value: isSignedUp)
                .onChange(of: appController.email) { _, newValue in
                    isEmailValid = isValidEmail(newValue)
                    authError = nil
                }
                .overlay(
                    !isEmailValid && !appController.email.isEmpty && !displayLoginScreen ?
                    HStack {
                        Spacer()
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.red)
                            .padding(.trailing)
                    }
                    : nil
                )
                .border((!isEmailValid && !appController.email.isEmpty && !displayLoginScreen) ? Color.red : Color.clear)
                .padding(.vertical, 5)

            

            SecureField("Password", text: $appController.password)
                .submitLabel(.done)
                .padding()
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 8))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .animation(.default, value: isSignedUp)
                .onChange(of: appController.password) { _, newValue in
                    isPasswordValid = isValidPassword(newValue)
                    authError = nil
                }
                .overlay(
                        !isPasswordValid && !appController.password.isEmpty && !displayLoginScreen ?
                        HStack {
                            Spacer()
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                                .padding(.trailing)
                        }
                        : nil
                )
                .border((!isPasswordValid && !appController.password.isEmpty && !displayLoginScreen) ? Color.red : Color.clear)
                .padding(.vertical, 5)
            
            

            Button {
                guard isValidEmail(appController.email) && isValidPassword(appController.password) else {
                    authError = "Your password or email is either incorrect or empty"
                    return
                }
                authenticate()
            } label: {
                Text(isSignedUp ? "Sign up" : "Log in")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isSignedUp ? Color("accentbrown") : Color("mainColor"))
                    .clipShape(.rect(cornerRadius: 8))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .foregroundStyle(isSignedUp ? .white : Color("darkgreen"))
                    .animation(.default, value: isSignedUp)
                    .padding(.vertical, 5)
            }
            .disabled(!isEmailValid || !isPasswordValid)
            .opacity(!isEmailValid || !isPasswordValid ? 0.6 : 1)

            if somethingWrong {
                Text("Something went wrong.")
                    .font(.caption)
                    .foregroundStyle(.red)
            } else {
                Text("")
            }
            
            if let error = authError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            } else {
                Text("")
            }
            
            if !isEmailValid && !appController.email.isEmpty && !displayLoginScreen {
                Text("The email has to be properly written.")
                    .font(.caption)
                    .foregroundColor(.red)
            } else {
                Text("")
            }
            
            if !isPasswordValid && !appController.password.isEmpty && !displayLoginScreen {
                Text("The password must contain at least 8 characters.")
                    .font(.caption)
                    .foregroundColor(.red)
            } else {
                Text("")
            }

            Spacer()
            Button(isSignedUp ? "I already have an account" : "I don't have an account") {
                isSignedUp.toggle()
                displayLoginScreen.toggle()
            }
        }
        .padding()
        .background(Color("mainerColor"))
    }

    func authenticate() {
        guard isValidEmail(appController.email) && isValidPassword(appController.password) else {
            authError = "Your password or email is incorrect"
            return
        }
        
        if isSignedUp {
            guard isValidUsername(username) else {
                authError = "Username must be at least 3 characters long and without spaces"
                return
            }
        }
        
        isSignedUp ? signUp() : signIn()
    }

    func signIn() {
        Task {
            do {
                try await appController.signIn()
            } catch {
                print("Error during sign in: \(error.localizedDescription)")
                if error.localizedDescription.contains("password") || error.localizedDescription.contains("user") {
                    authError = "Your password or email is incorrect"
                } else {
                    somethingWrong.toggle()
                }
            }
        }
    }

    func signUp() {
        Task {
            do {
                if await userViewModel.isUsernameTaken(username) {
                    authError = "This username is already taken"
                    return
                }
                userViewModel.addUser(
                    id: appController.currentUser?.id,
                    username: username.lowercased(),
                    userBio: "", 
                    userBioLink: "", 
                    userEmail: appController.email
                )
                appController.updateUserProfile(username.lowercased())
                try await appController.signUp()
                
                try await appController.signIn()
            } catch {
                print("Error during sign up: \(error.localizedDescription)")
                if error.localizedDescription.contains("password") || error.localizedDescription.contains("email") {
                    authError = "Your password or email is incorrect"
                } else if error.localizedDescription.contains("email already in use") {
                    authError = "This email is already registered"
                } else {
                    somethingWrong.toggle()
                }
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView().environmentObject(AppController())
    }
}
