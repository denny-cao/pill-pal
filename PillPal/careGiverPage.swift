//
//  careGiverPage.swift
//  PillPal
//
//  Created by Efrain Angon-Cruz on 2/17/24.
//

import Foundation
import SwiftUI

struct careGiverSignInView: View {
    
    @State private var phoneNumber: String = ""


    
    var body: some View {
        VStack {
            Text("Care Giver Portal")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .padding(.bottom, 42)
            TextField("Enter Phone Number", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .onChange(of: phoneNumber) { newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered != newValue {
                                    self.phoneNumber = filtered
                                }
                            }
            Button(action: {}) {
                Text("Sign In")
                        .fontWeight(.heavy)
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                    }
                }
    }
}

struct careAddPatientView: View {
    //@AppStorage("patientCode") private var patientCode: String = ""
    @State private var patientCode: String = ""

        var body: some View {
            //NavigationStack {
            //    Form {
            //        TextField("Patient Code", text: $patientCode)
            //        TextField("Patient Name", text: $patientName)
            //    }
            //    .navigationBarTitle("Add New Patient")
            //}
            VStack {
                Text("Add New Patient")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .padding(.bottom, 42)
                TextField("Enter Patient Code", text: $patientCode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .onChange(of: patientCode) { newValue in
                                    let filtered = newValue.filter { $0.isNumber }
                                    if filtered != newValue {
                                        self.patientCode = filtered
                                    }
                                }
                Button(action: {}) {
                    Text("Add Patient")
                            .fontWeight(.heavy)
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                        }
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
        guard let url = URL(string: "http://127.0.0.1:8000") else {
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
struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        careAddPatientView()
        careGiverSignInView()
        testingFlask()
    }
}
