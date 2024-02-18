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
            
            NavigationLink(destination: UniqueID()) {
                Text("Submit")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Patient Portal")
    }
}

struct CaregiverView: View {
    var body: some View {
        Text("Caregiver View")
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
            Text("Thank you for your information!")
            Text("Your PillPal ID:  # \(randomCode)")
                .font(.title)
        }
        .navigationTitle("PillPal Unique ID")
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