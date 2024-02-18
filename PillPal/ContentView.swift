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
    @State private var generatedCode: String = ""
    
    private func generateRandomCode() -> String {
            let digits = "123456789"
            return String((0..<6).map{ _ in digits.randomElement()! })
        }
    
    func addPatient(uid: Int, name: String, phoneNumber2: String) {
        guard let url = URL(string: "http://127.0.0.1:5000/api/new-patient") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: Any] = [
            "uid": uid,
            "name": name,
            "phone_number": phoneNumber2
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                if (200..<300).contains(httpResponse.statusCode) {
                    print("Patient added successfully")
                    // Handle successful response
                } else {
                    print("Error: \(httpResponse.statusCode)")
                    // Handle other status codes
                }
            }.resume()
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
    }
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
            
            NavigationLink(destination: UniqueID(randomCode: generatedCode), isActive: $isSubmitButtonTapped) {
                            Button(action: {
                                generatedCode = generateRandomCode()
                                let uid = Int(generatedCode) ?? 0
                                addPatient(uid: uid, name: name, phoneNumber2: phoneNumber)
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
        }
        .navigationTitle("Patient Portal")
    }
}

struct UniqueID: View {
    var randomCode: String
    @StateObject private var viewModel = NotificationSubscriptionViewModel()

    var body: some View {
        VStack {
            Text("Thank you for your information!")
            Text("Your PillPal ID:  # \(randomCode)")
                .font(.title)
        }
        Button(action: {
            viewModel.subscribeToNotifications()
        }) {
            Text("Turn on Notification!")
        }
        .padding()
        .navigationTitle("PillPal Unique ID")
        .navigationBarBackButtonHidden(true)
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
                NavigationLink(destination: careGiverSignInView()) {
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
