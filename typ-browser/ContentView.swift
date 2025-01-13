//
//  ContentView.swift
//  typ-browser
//
//  Created by Apurva Mishra on 31/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: UUID = UUID()
    @State private var url: String = ""
    @State private var update_index = 0
    @State private var global = 0
    @State private var isSidebarVisible = false
    @State private var sidebarWidth: CGFloat = 300
    @State private var previousSidebarWidth: CGFloat = 300
    @State private var isHoveringDivider = false // Track if hovering over divider area
    
    var body: some View {
        HStack(spacing: 0) {
            PDFViewer(url: $url, global: $global)
                .frame(maxWidth: .infinity)
            
            if isSidebarVisible {
                // Invisible Divider (Resize Handle)
                Group {
                    ResizeHandle(isHovering: $isHoveringDivider)
                        .frame(width: 5)
                        
                        .onHover { hovering in // Track hover state over the divider
                            isHoveringDivider = hovering
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newWidth = max(100, min(sidebarWidth - value.translation.width, 500))
                                    sidebarWidth = newWidth
                                }
                                .onEnded { _ in
                                    previousSidebarWidth = sidebarWidth
                                }
                        )
                        .transition(.move(edge: .trailing))
                    
                    
                    // Sidebar View
                    FileEditorView()
                        .frame(width: sidebarWidth)
                        .transition(.move(edge: .trailing))
                }
                    
            }
        }
        .frame(minWidth: 500, idealWidth: 700, minHeight: 300)
        .onChange(of: isHoveringDivider) {
            if isHoveringDivider {
                NSCursor.resizeLeftRight.push() // Change cursor on hover
            } else {
                NSCursor.pop() // Restore default cursor
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) { // Example: Reload button
                Button(action: {
                    let arg = url.cString(using: .utf8)!
                    let success = run(arg);
                    global += 1
                    print(success)
                    
                }) {
                    Image(systemName: "play.fill")
                }
            }
            ToolbarItem(placement: .automatic) { // Example: Reload button
                Button(action: {}) {
                    Image(systemName: "arrow.clockwise")
                }
            }
            
            ToolbarItem(placement: .cancellationAction) { // Example: Close Sidebar
                Button(action: {
                    withAnimation {
                        isSidebarVisible = false
                        sidebarWidth = 0 // Set width to 0 for closing animation
                    }
                }) {
                    Image(systemName: "xmark")
                }
                //.disabled(!isSidebarVisible)
            }
            
            ToolbarItem(placement: .confirmationAction) { // Example: Toggle sidebar
                Button(action: {
                    withAnimation {
                        if isSidebarVisible {
                            // If hiding, set width to 0 for smooth animation
                            sidebarWidth = 0
                        } else {
                            // If showing, restore to previous width
                            sidebarWidth = previousSidebarWidth
                        }
                        isSidebarVisible.toggle()
                    }
                }) {
                    Image(systemName: "sidebar.right")
                }
            }
            
            ToolbarItem(placement: .automatic) {
                HStack {
                    TextField("Enter Path...", text: $url)
                        .frame(width: 200)
                        .onSubmit {
                            print(url)
                        }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .navigationTitle("Typorium")
        
    }
}

struct ResizeHandle: View {
    @Binding var isHovering: Bool
    
    var body: some View {
        Rectangle()
            .fill(Color.accentColor) // Make the divider invisible
            .frame(maxHeight: .infinity) // Make the divider full height
    }
}

#Preview {
    ContentView()
}

