import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

struct HealthRecordAdd: View {
    @State private var healthRecordPDFData: Data? = nil // Data to store the selected PDF
    @State private var selectedPDFName: String? = nil
    @State private var isDocumentPickerPresented = false

    private func handlePDFSelection(result: Result<URL, Error>) {
        if case let .success(url) = result {
            do {
                // Convert PDF to Data
                let pdfData = try Data(contentsOf: url)
                healthRecordPDFData = pdfData
                // Get selected PDF name
                selectedPDFName = url.lastPathComponent
            } catch {
                print("Error converting PDF to data: \(error)")
            }
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Upload Health Records")) {
                    Button("Upload PDF") {
                        // Present document picker to select PDF
                        isDocumentPickerPresented.toggle()
                    }
                }
                
                // Display selected PDF filename
                if let selectedPDFName = selectedPDFName {
                    Text("Uploaded PDF: \(selectedPDFName)")
                }
            }
            .sheet(isPresented: $isDocumentPickerPresented) {
                DocumentPicker(documentTypes: [UTType.pdf.identifier], handleResult: handlePDFSelection)
            }
            .navigationTitle("Add Health Record")
        }
    }
}

struct HealthRecordAdd_Previews: PreviewProvider {
    static var previews: some View {
        HealthRecordAdd()
    }
}
