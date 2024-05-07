//
//  Medicine_ViewModel.swift
//  Patient_HMS
//
//  Created by Arnav on 07/05/24.
//

import Foundation
import SwiftUI
import Firebase
class Medicine_ViewModel: ObservableObject {
    @EnvironmentObject var authViewModel : AuthViewModel
    private let db = Firestore.firestore()

    func addMedicine(medicine: Medicines, userid: String) {
        do {
            var newMedicine = medicine // Create a mutable copy of the medicine object
            let documentRef = try db.collection("medicines/\(userid)/userMedicines").addDocument(from: newMedicine)
            newMedicine.id = documentRef.documentID // Set the id field of the medicine object to the document ID
            try db.collection("medicines/\(userid)/userMedicines").document(documentRef.documentID).setData(from: newMedicine)
        } catch {
            print("Error adding medicine: \(error.localizedDescription)")
        }
    }

    func updateMedicine(medicineID: String, userid: String, withData data: [String: Any]) {

        db.collection("medicines/\(userid)/userMedicines").document(medicineID).setData(data, merge: true)
    }

    func deleteMedicine(medicineID: String, userid: String) {

        db.collection("medicines/\(userid)/userMedicines").document(medicineID).delete()
    }


    func getAllMedicines(userid: String, completion: @escaping ([Medicines]) -> Void) {
        let collectionRef = db.collection("medicines/\(userid)/userMedicines")

        collectionRef.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("Error retrieving medicines: \(error?.localizedDescription ?? "")")
                completion([])
                return
            }

            let medicines = snapshot.documents.compactMap { document -> Medicines? in
                try? document.data(as: Medicines.self)
            }
            completion(medicines)
        }
    }

}

