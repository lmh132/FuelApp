//
//  SelectManyButton.swift
//  Fuel
//
//  Created by Leo Hu on 10/25/24.
//

import SwiftUI

struct SelectManyButton: View {
    @State private var marked = false
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
            marked.toggle()
        }) {
            HStack {
                Text(text)
                Image(systemName: marked ? "checkmark.square.fill" : "square")
            }
            .foregroundColor(.black)
        }
    }
}

#Preview {
    SelectManyButton(text: "test", action: {})
}
