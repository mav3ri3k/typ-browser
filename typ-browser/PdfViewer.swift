//
//  PdfView.swift
//  typ-browser
//
//  Created by Apurva Mishra on 01/01/25.
//

import SwiftUI
import PDFKit

struct PDFViewer: NSViewRepresentable {
    let url: URL

    init(_ url: URL) {
        self.url = url
    }

    func makeNSView(context: NSViewRepresentableContext<PDFViewer>) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateNSView(_ nsView: PDFView, context: NSViewRepresentableContext<PDFViewer>) {
        // Update the view if needed, e.g., if the URL changes.
    }
}

