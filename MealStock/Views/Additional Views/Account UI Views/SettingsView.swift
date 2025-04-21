//
//  SettingsView.swift
//  MealStock
//
//  Created by Jiří on 28.10.2024.
//
import SwiftUI

struct SettingsView: View {
    @ObservedObject private var appController = AppController()
    @State private var showingAlert = false
    @State private var toggle = false
    
    var body: some View {
        NavigationStack {
            List {
                    Button() { //TODO
                    } label: {
                        Toggle(isOn: $toggle) {
                            Text("Dark mode")
                                .foregroundStyle(.black)
                        }
                    }
                
                NavigationLink(destination: EditProfileView()) { //TODO
                    Text("Edit profile")
                }
                
                Link("Visit Our Website", destination: URL(string: "https://jrkdotexe.github.io/MealStock_web/")!)
                
                Link("Contact Us", destination: URL(string: "https://jrkdotexe.github.io/MealStock_web/contact")!)
                
                Link("Terms of Service", destination: URL(string: "https://jrkdotexe.github.io/MealStock_web/")!)
                
                Link("Privacy Policy", destination: URL(string: "https://jrkdotexe.github.io/MealStock_web/")!)
                
                Button("Log out", role: .destructive) {
                    do {
                        try appController.signOut()
                    } catch {
                        print("Failed to log out: \(error.localizedDescription)")
                    }
                }

                Button("Delete account", role: .destructive) {
                    showingAlert.toggle()
                }
                .alert("Are you sure you want to delete your account?", isPresented: $showingAlert) {
                    Button("Delete account", role: .destructive) {
                                appController.deleteUser()
                            }
                        }
                
            }
            .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Settings")
                                .foregroundStyle(Color("darkgreen"))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                    }
        }
    }
}

struct Setting: Hashable {
    let title: String
    let color: Color
    let imageName: String
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(AppController())
        MainTabView().environmentObject(AppController())
    }
}
