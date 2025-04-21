//
//  ContactUsView.swift
//  MealStock
//
//  Created by Jiří on 14.10.2024.
//

import SwiftUI

struct ContactUsView: View {
    @State private var emailAddress = ""
      @State private var message = "Write your message here..."
      @State private var includeLogs = false
      
      var body: some View {
        Form {
          Section(header: Text("How can we reach you?")) {
            TextField("Email Address", text: $emailAddress)
          }
          Section(header: Text("Briefly explain what's going on.")) {
            TextEditor(text: $message)
          }
          Section(footer: Text("This information will be sent anonymously.")) {
            Toggle("Include Logs", isOn: $includeLogs)
          }
          Button("Submit", action: {
          })
          
        }
        .onSubmit {
            print("Form submitted")
            print("Email Address: \(emailAddress)")
            print("Message: \(message)")
        }
      }
    }

#Preview {
    ContactUsView()
}
