import SwiftUI
import Firebase
import FirebaseStorage
import MobileCoreServices
import QuickLook
import PDFKit

struct HealthRecordAdd: View {
    @State private var healthRecordPDFData: Data? = nil
    @State private var selectedPDFName: String? = nil
    @State private var isDocumentPickerPresented = false
    @State private var uploadProgress: Double = 0.0
    @State private var isUploading: Bool = false
    @State private var uploadedDocuments: [StorageReference] = []

    @State private var isPreviewPresented = false
    @State private var previewURL: URL?

    private func handlePDFSelection(result: Result<[URL], Error>) {
        if case let .success(urls) = result, let url = urls.first {
            do {
                let pdfData = try Data(contentsOf: url)
                healthRecordPDFData = pdfData
                selectedPDFName = url.lastPathComponent
                uploadPDFToFirebase()
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
                        isDocumentPickerPresented.toggle()
                    }
                }
                
                if let selectedPDFName = selectedPDFName {
                    
                }
                
                Section(header: Text("Uploaded Documents")) {
                    ForEach(uploadedDocuments, id: \.self) { documentRef in
                        HStack {
                            
                            
                            HStack {
                                Button(action: {
                                    viewDocument(documentRef: documentRef)
                                }) {
                                    Text(documentRef.name)
                                }
                            }
                            Spacer()
                            
                            
                                    Image(systemName: "square.and.arrow.down")
                                    .frame(width : 40 , height : 40)
                                    .foregroundColor(Color.blue)
                                    .onTapGesture {
                                        downloadDocument(documentRef: documentRef)
                                    }
                            
                            
                            
                            
                            
                            
                            HStack {
                                
                                
                                Image(systemName: "trash")
                                
                                    .foregroundColor(Color.red)
                                    .onTapGesture {
                                        deleteDocument(documentRef: documentRef)
                                    }
                                
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $isDocumentPickerPresented) {
                DocumentPicker { urls in
                    handlePDFSelection(result: .success(urls))
                }
            }
            .navigationTitle("Add Health Record")
        }
        .onAppear {
            fetchUploadedDocuments()
        }
        .sheet(isPresented: $isPreviewPresented) {
            if let previewURL = previewURL, let pdfDocument = PDFDocument(url: previewURL) {
                PDFPreviewView(pdfDocument: pdfDocument)
            } else {
                Text("Error displaying PDF")
            }
        }
    }

    func uploadPDFToFirebase() {
        guard let pdfData = healthRecordPDFData else {
            print("No PDF data to upload")
            return
        }
        
        isUploading = true
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let pdfRef = storageRef.child("health_records/\(UUID().uuidString).pdf")
        
        pdfRef.putData(pdfData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading PDF: \(error.localizedDescription)")
            } else {
                print("PDF uploaded successfully")
                uploadedDocuments.append(pdfRef)
            }
            isUploading = false
        }
    }
    
    func fetchUploadedDocuments() {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("health_records")
        
        storageRef.listAll { result, error in
            if let error = error {
                print("Error fetching uploaded documents: \(error.localizedDescription)")
            } else {
                uploadedDocuments = result!.items
            }
        }
    }
    
    func viewDocument(documentRef: StorageReference) {
        documentRef.downloadURL { url, error in
            guard let downloadURL = url, error == nil else {
                print("Error getting document URL: \(error?.localizedDescription ?? "")")
                return
            }
            
            // Perform asynchronous download using URLSession
            URLSession.shared.dataTask(with: downloadURL) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error downloading document: \(error?.localizedDescription ?? "")")
                    return
                }
                
                // Process downloaded data
                DispatchQueue.main.async {
                    if let pdfDocument = PDFDocument(data: data) {
                        // You can further customize the PDFView here (zoom, annotations etc.)
                        previewURL = downloadURL
                        isPreviewPresented = true
                    } else {
                        // Handle potential data error
                    }
                }
            }.resume()
        }
    }

    
    func downloadDocument(documentRef: StorageReference) {
        documentRef.downloadURL { url, error in
            guard let downloadURL = url, error == nil else {
                print("Error getting document URL: \(error?.localizedDescription ?? "")")
                return
            }
            
            // Initiate the download using URLSession
            URLSession.shared.downloadTask(with: downloadURL) { localURL, response, error in
                guard let localURL = localURL, error == nil else {
                    print("Error downloading document: \(error?.localizedDescription ?? "")")
                    return
                }
                
                // Get the documents directory URL
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // Generate a unique file name for the downloaded file
                let uniqueFilename = UUID().uuidString + ".pdf"
                let destinationURL = documentsDirectory.appendingPathComponent(uniqueFilename)
                
                do {
                    // Move the downloaded file to the destination URL
                    try FileManager.default.moveItem(at: localURL, to: destinationURL)
                    print("Document downloaded successfully at: \(destinationURL)")
                } catch {
                    print("Error moving downloaded document: \(error.localizedDescription)")
                }
            }.resume()
        }
    }


    
    func deleteDocument(documentRef: StorageReference) {
        documentRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                print("Document deleted successfully")
                // Remove the deleted document from the uploadedDocuments array
                if let index = uploadedDocuments.firstIndex(of: documentRef) {
                    uploadedDocuments.remove(at: index)
                }
            }
        }
    }
}

struct HealthRecordAdd_Previews: PreviewProvider {
    static var previews: some View {
        HealthRecordAdd()
    }
}

struct PDFPreviewView: View {
    let pdfDocument: PDFDocument

    var body: some View {
        ZStack {
            PDFKitRepresentedView(pdfDocument: pdfDocument)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let pdfDocument: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true // Enable auto scaling
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // Update the view if needed
    }
}



