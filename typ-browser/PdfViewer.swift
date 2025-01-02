//
//  PdfView.swift
//  typ-browser
//
//  Created by Apurva Mishra on 01/01/25.
//

import SwiftUI
import PDFKit

struct PDFViewer: NSViewRepresentable {
    @Binding var url: String
    @Binding var global: Int
    @State private var cur = 0

    func changeURLExtension(_ url: URL, to newExtension: String) -> URL {
        url.deletingPathExtension().appendingPathExtension(newExtension)
    }
    
    func makeNSView(context: NSViewRepresentableContext<PDFViewer>) -> PDFView {
        let pdfURL = Bundle.main.url(forResource: "ass", withExtension: "pdf")!
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: pdfURL)
        pdfView.autoScales = true
        //pdfView.backgroundColor = NSColor.systemBlue
        return pdfView
    }


    func updateNSView(_ nsView: PDFView, context: Context) {
        if (cur < global) {
            cur = global
            guard var pdfURL = URL(string: url), !url.isEmpty else {
                nsView.document = nil // Clear the document if the URL is invalid or empty
                return
            }
            pdfURL = changeURLExtension(pdfURL, to: "pdf")
            
            if let pdfDocument = PDFDocument(url: pdfURL) {
                nsView.document = pdfDocument
            } else {
                print("Failed to load PDF from URL: \(pdfURL)")
            }
            
        }
    }
}
