//
//  Toolbar.swift
//  typ-browser
//
//  Created by Apurva Mishra on 01/01/25.
//

import SwiftUI

struct Toolb: View {
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            Text("Main content area")
                .navigationTitle("Search") // Set a title for clarity
                .toolbar {
                    // Close Button (placed on the trailing side)
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {
                            // Handle close action (e.g., dismiss view, exit search mode)
                            print("Close button tapped")
                        }) {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .help("Close") // Use .help for tooltips on macOS
                    }

                    // Search Field and Go Button (placed in the center)
                    ToolbarItem(placement: .principal) {
                        HStack {
                            TextField("Search", text: $searchText)
                                .frame(width: 200) // Adjust width as needed
                                .textFieldStyle(RoundedBorderTextFieldStyle()) // Optional styling

                            Button(action: {
                                // Handle search action
                                print("Go button tapped, search text: \(searchText)")
                            }) {
                                Text("Go")
                            }
                            .help("Search")
                        }
                    }
                }
        }
    }
}

