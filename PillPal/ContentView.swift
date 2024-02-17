//
//  ContentView.swift
//  PillPal
//
//  Created by Amesha Banjara on 2/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "pill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Welcome to...")
                Text("Pill Pal!")
                ButtonView(
                    label: "I'm a Caregiver!",
                    action: {
                        print("Caregiver")
                    }
                )
                NavigationLink(destination: PatientView()) {
                    ButtonView(
                        label: "I'm a Patient!",
                        action: {
                            print("Patient")
                        }
                    )
                }
            }
            .padding()
            .background(Color.blue.opacity(0.2))
            .navigationTitle("Pill Pal Home")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
