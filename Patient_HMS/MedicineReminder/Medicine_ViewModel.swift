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

    func updateMedicine(medicine: Medicines, userid: String) {
        guard let medicineID = medicine.id else {
            // Handle the case where medicineID or userid is nil
            return
        }
        // Convert Medicine object to dictionary
        let data: [String: Any] = [
            "name": medicine.name,
            "dosage": medicine.dosage,
            "times": medicine.times,
            "daysOfWeek": medicine.daysOfWeek,
            "startDate": medicine.startDate,
            "endDate": medicine.endDate
        ]
        // Update the medicine document in Firestore
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
    
    func getTodayMedicines(userid: String, completion: @escaping ([Medicines]) -> Void) {
        let collectionRef = db.collection("medicines/\(userid)/userMedicines")

        collectionRef.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("Error retrieving medicines: \(error?.localizedDescription ?? "")")
                completion([])
                return
            }

            let medicines = snapshot.documents.compactMap { document -> Medicines? in
                guard let medicineData = try? document.data(as: Medicines.self) else {
                    // Failed to parse medicine data
                    return nil
                }

                // Check if today's date is within the start and end date range
                let currentDate = Date()
                if currentDate >= medicineData.startDate && currentDate <= medicineData.endDate {
                    return medicineData
                } else {
                    return nil
                }
            }
            completion(medicines)
        }
    }





}

