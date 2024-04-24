import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    var documentTypes: [String]
    var handleResult: (Result<URL, Error>) -> Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let types = documentTypes.map { UTType(filenameExtension: $0) }.compactMap { $0 }
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        controller.delegate = context.coordinator
        controller.allowsMultipleSelection = false // Allow only single selection
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // Nothing to update
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                parent.handleResult(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            parent.handleResult(.success(url))
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.handleResult(.failure(NSError(domain: "", code: 0, userInfo: nil)))
        }
    }
}
