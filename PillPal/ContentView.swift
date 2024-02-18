//
//  ContentView.swift
//  PillPal
//
//  Created by Amesha Banjara on 2/17/24.
//

import SwiftUI

struct PatientView: View {
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var isSubmitButtonTapped = false
    
    var body: some View {
        
        VStack {
            Text("Welcome to your PillPal Patient Portal!")
                .font(.title2)
                .padding()
            
            TextField("Please enter your name here...", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Please enter your phone number here...", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: phoneNumber) { newValue in
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered != newValue {
                        self.phoneNumber = filtered
                    }
                }
            
            NavigationLink(destination: UniqueID(), isActive: $isSubmitButtonTapped) {
                Button(action: {
                    isSubmitButtonTapped = true
                }) {
                    Text("Submit")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle()) // should be button now
            }
            .padding()
            .navigationTitle("Patient Portal")
        }
    }
}

struct CaregiverView: View {
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    
    var body: some View {
        
        VStack {
            Text("Welcome to your PillPal Caregiver Portal!")
                .font(.title2)
                .padding()
            
            TextField("Please enter your name here...", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Please enter your phone number here...", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: phoneNumber) { newValue in
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered != newValue {
                        self.phoneNumber = filtered
                    }
                }
            NavigationLink(destination: PatientConfirmation()) {
                Text("Submit")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Caregiver Portal")
    }
}

struct UniqueID: View {
    var randomCode: String {
        let digits = "123456789"
        let code = String((0..<6).map{ _ in digits.randomElement()! })
        return code
    }
    
    var body: some View {
        VStack {
            Text("Your submission is a SUCCESS!")
            Text("Remember to NOT share your PillPal UniqueID with anyone but your trusted caregiver.")
                .padding()
                .multilineTextAlignment(.center)
            Image(systemName: "smiley")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .padding()
            
            Text("Your PillPal ID:  # \(randomCode)")
                .font(.title)
        }
        .navigationTitle("PillPal Unique ID")
        .navigationBarBackButtonHidden(true)
    }
}

struct PatientConfirmation: View {
    @State var uniqueID = ""
    
    var body: some View {
        VStack {
            Text("Enter your patient's PillPal Unique ID below:")
            TextField("######", text: $uniqueID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .onChange(of: uniqueID) { newValue in
            let filtered = newValue.filter { $0.isNumber }
            if filtered != newValue {
                self.uniqueID = filtered
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to...")
                Text("Pill Pal!")
                    .font(.headline)
                
                Image(systemName: "pill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                
                NavigationLink(destination: PatientView()) {
                    Text("I'm a Patient!")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.bottom, 5)
                NavigationLink(destination: CaregiverView()) {
                    Text("I'm a Caregiver!")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.2))
            .navigationTitle("PillPal Home")
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
