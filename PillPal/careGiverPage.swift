//
//  careGiverPage.swift
//  PillPal
//
//  Created by Efrain Angon-Cruz on 2/17/24.
//

import Foundation
import SwiftUI
import Combine
import UserNotifications

struct careGiverSignInView: View {
    
    @State private var careName: String = ""
    @State private var patientCode: String = ""
    @State private var isSubmitButtonTapped = false
    
    func addCaretaker(uid: Int, name: String) {
        guard let url = URL(string: "http://127.0.0.1:5000/api/new-caretaker") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: Any] = [
            "uid": uid,
            "name": name
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
                    print("Caretaker added successfully")
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
            Text("Care Giver Portal")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .padding(.bottom, 42)
            TextField("Please enter your name here...", text: $careName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Enter Patient Code", text: $patientCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .onChange(of: patientCode) { newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered != newValue {
                                    self.patientCode = filtered
                                }
                            }
            NavigationLink(destination: careAddMedicine(patientID:patientCode), isActive: $isSubmitButtonTapped) {
                            Button(action: {
                                let uid = Int(patientCode) ?? 0
                                addCaretaker(uid: uid, name: careName)
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
                }
    }
}

struct careAddMedicine: View {
    var patientID: String
    @State private var medName = ""
        @State private var dose = ""
    @State private var selectedNumber = 1

    func addMedication(name: String, dosage: String, interval: Int, patientID: Int) {
        guard let url = URL(string: "http://127.0.0.1:5000/api/add-medications") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: Any] = [
            "name": name,
            "dosage": dosage,
            "interval": interval,
            "patient_id": patientID
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
                    print("Medication added successfully")
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
            NavigationView {
                Form {
                    Section(header: Text("Medicine Information")) {
                        TextField("Name", text: $medName)
                        TextField("Dosage", text: $dose)
                    }
                    
                    Section(header: Text("Time Interval(Hours)")) {
                        Picker("Number", selection: $selectedNumber) {
                                                ForEach(1..<49) { number in
                                                    Text("\(number)").tag(number)
                                                }
                                            }
                                            .pickerStyle(WheelPickerStyle())
                    }
                    
                    Section {
                        let localPatientID = Int(patientID) ?? 0
                        Button(action: {
                            addMedication(name: medName, dosage: dose, interval: selectedNumber, patientID: localPatientID)
                        }) {
                            Text("Submit")
                        }
                    }
                }
                .navigationTitle("Add Medicine")
            }
        }
}

struct testingFlask: View {
    @State private var message = "Loading..."
    
    var body: some View {
        VStack {
            Text(message)
                .padding()
                .onAppear {
                    fetchData()
                }
        }
    }
    func fetchData() {
        guard let url = URL(string: "http://http://127.0.0.1:5000/") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let message = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.message = message
                }
            } else {
                print("Cannot parse data")
            }
        }.resume()
    }
}



class NotificationSubscriptionViewModel: ObservableObject {
    func subscribeToNotifications() {
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting authorization: \(error)")
            } else {
                print("Permission granted: \(granted)")
            }
        }
    }
}

struct notiView: View {
    @StateObject private var viewModel = NotificationSubscriptionViewModel()

    var body: some View {
        Button(action: {
            viewModel.subscribeToNotifications()
        }) {
            Text("Turn on Notification!")
        }
        .padding()
    }
}


struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        careGiverSignInView()
        testingFlask()
    }
}
