//
//  FileEditorView.swift
//  typ-browser
//
//  Created by Apurva Mishra on 11/01/25.
//

import SwiftUI

struct FileEditorView: View {
    @State private var text: String = "Some text..."
    
    var body: some View {
        VStack {
            TextEditor(text: $text)
                .padding()
        }
    }
}

#Preview {
    FileEditorView()
}
