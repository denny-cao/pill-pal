//
//  ContentView.swift
//  PillPal
//
//  Created by Amesha Banjara on 2/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "pill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Welcome to...")
            Text("PillPal!")
            ButtonView(
                label: "Caregiver Portal",
                action: {
                    print("Caregiver Status")
                }
                )
            ButtonView(
                label: "Patient Portal",
                action: {
                    print("Patient Status")
                }
            )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
        }
        .padding()
        .background(Color(red: 1.0, green: 0.8, blue: 0.8))
    }
}

#Preview {
    ContentView()
}
