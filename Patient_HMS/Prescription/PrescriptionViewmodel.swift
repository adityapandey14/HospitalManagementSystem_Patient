//
//  PrescriptionViewmodel.swift
//  Patient_HMS
//
//  Created by Arnav on 06/05/24.
//
import Firebase
class PrescriptionViewModel: ObservableObject {
    @Published var prescriptions = [Prescription]()
        
        private var db = Firestore.firestore()
    
    func fetchPrescriptions(for patientID: String, completion: @escaping ([Prescription]) -> Void) {
        db.collection("prescriptions").whereField("patientID", isEqualTo: patientID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching prescriptions: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No prescriptions found")
                completion([])
                return
            }
            
            let prescriptions = documents.compactMap { document -> Prescription? in
                let data = document.data()
                let medicineData = data["medicines"] as? [[String: String]] ?? []
                let medicines = medicineData.map { Medicine(name: $0["name"] ?? "", dosage: $0["dosage"] ?? "") }
                let instructions = data["instructions"] as? String ?? ""
                return Prescription(patientID: patientID, medicines: medicines, instructions: instructions)
            }
            
            completion(prescriptions)
        }
    }

}

