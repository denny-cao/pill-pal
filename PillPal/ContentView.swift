//
//  ContentView.swift
//  PillPal
//
//  Created by Amesha Banjara on 2/17/24.
//

import SwiftUI

struct PatientView: View {
    var body: some View {
        Text("Welcome to your PillPal Patient Portal!")
        
            .navigationTitle("Patient Portal")
    }
}

struct CaregiverView: View {
    var body: some View {
        Text("Caregiver View")
        Text("Enter your number and name por favor")
            .navigationTitle("Caregiver Portal")
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to...")
                Text("Pill Pal!")
                    .font(.headline)
                    //.padding()
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
