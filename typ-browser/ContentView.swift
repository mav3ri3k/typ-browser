//
//  ContentView.swift
//  typ-browser
//
//  Created by Apurva Mishra on 31/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var sum: UInt64 = 0
    @State private var num1: String = "0"
    @State private var num2: String = "0"

    var body: some View {
        VStack {
            Text("Sum: \(sum)")
                .padding()
            HStack {
                TextField("Number 1", text: $num1)
                    .padding()
                TextField("Number 2", text: $num2)
                    .padding()
            }
            Button("Calculate Sum") {
                calculateSum()
            }
        }
        .padding()
    }

    func calculateSum() {
        guard let left = UInt64(num1), let right = UInt64(num2) else {
            sum = 90 // Or handle the error in a more user-friendly way
            return
        }
        sum = add(left, right)
    }
}

#Preview {
    ContentView()
}
