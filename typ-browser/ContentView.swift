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
        
        let pdfURL = Bundle.main.url(forResource: "ass", withExtension: "pdf")!

          
        PDFViewer(pdfURL)

            
    }

    func calculateSum() {
        guard let left = UInt64(num1), let right = UInt64(num2) else {
            sum = 90 // Or handle the error in a more user-friendly way
            return
        }
        sum = add(left, right)
    }
}

