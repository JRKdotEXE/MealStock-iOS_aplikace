//
//  EditProfileView.swift
//  MealStock
//
//  Created by Jiří on 19.03.2025.
//
import SwiftUI
import FirebaseFirestore

struct EditProfileView: View {
    @EnvironmentObject private var appController: AppController
    @State private var name: String = ""
    @State private var bio: String = ""
    @State private var isAlertPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
            ZStack {
                Color.mainer.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Section("Name") {
                        TextField("Name", text: $name)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .clipShape(.rect(cornerRadius: 10))
                            .padding(.horizontal)
                        
                        
                        Button {
                            if name != appController.username {
                                appController.updateUserProfile(name)
                            } else {
                                isAlertPresented = true
                            }
                        } label: {
                            Text("Edit username")
                                .brownButton()
                        }
                        .alert(isPresented: $isAlertPresented) {
                            Alert(title: Text("Username not valid"), message: Text("Please enter a different username."), dismissButton: .default(Text("OK")))
                        }
                    }
                    Section("Bio") {
                        TextEditor(text: $bio)
                            .frame(height: 150)
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                    }

                    Button {
                        if bio != "" {
                            appController.updateBio(bio)
                        }
                    } label: {
                        Text("Edit bio")
                            .brownButton()
                    }
                    
                }
                .padding()
                .onAppear {
                    bio = appController.currentUser?.userBio ?? ""
                }
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(backgroundColor: .main, titleColor: .darkergreen)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Edit profile")
                        .foregroundStyle(Color("darkgreen"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
            
        }
        }
    }
}
