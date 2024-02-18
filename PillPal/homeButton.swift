//
//  homeButton.swift
//  PillPal
//
//  Created by Amesha Banjara on 2/17/24.
//

import Foundation
import SwiftUI
struct ButtonView: View {
    let label: String
    let action: () -> Void
    var body: some View {
            Button(action: action) {
                Text(label)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
    }
