//
//  BillsViewModel.swift
//  Patient_HMS
//
//  Created by Arnav on 09/05/24.
//

import Foundation
import Firebase
struct BillItem: Identifiable, Codable {
    var id = UUID()
    var description: String
    var quantity: Int?
    var pricePerService: Double?
    var totalCharge: Double?
}

// Bill Struct
struct Bill: Identifiable, Codable {
    var id : String?
    var creationTimestamp = Date()

    var hospitalName: String
    var hospitalAddress: String
    var hospitalContactInfo: String

    var patientID: String
    var doctorID: String

    var billingDate = Date()
    var items: [BillItem]

    var totalAmountDue: Double?
    var amountPaid: Double?
    var paymentMethod: String
    var paymentDate = Date()
    var outstandingBalance: Double?

    var notes: String?

    var discountsOrAdjustments: Double?
    var taxes: Double?
    var referralInfo: String?
}

class BillViewModel: ObservableObject {
    @Published var bills = [Bill]()
    private var db = Firestore.firestore()

    func addBill(_ bill: Bill) {
        do {
            let _ = try db.collection("bills").addDocument(from: bill)
        } catch {
            print("Error adding bill: \(error.localizedDescription)")
        }
    }
    

    func fetchBills(patientID: String) {
        db.collection("bills")
            .whereField("patientID", isEqualTo: patientID)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.bills = documents.compactMap { queryDocumentSnapshot in
                    do {
                        let bill = try queryDocumentSnapshot.data(as: Bill.self)
                        
                        return bill
                    } catch {
                        print("Error decoding bill: \(error.localizedDescription)")
                        return nil
                    }
                }
            }
        
    }


    }
