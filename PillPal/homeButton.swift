//
//  homeButton.swift
//  PillPal
//
//  Created by Amesha Banjara on 2/17/24.
//

import Foundation
import SwiftUI

struct ButtonView: View {
    var label: String
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(label)
        }
    }
}
