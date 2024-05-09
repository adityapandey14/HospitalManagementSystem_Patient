//
//  BillsView.swift
//  Patient_HMS
//
//  Created by Arnav on 09/05/24.
//

import Foundation
import SwiftUI

struct BillsView: View {
    @EnvironmentObject var billviewmodel:BillViewModel
    @EnvironmentObject var viewModel:AuthViewModel


    var body: some View {
        VStack {
            Text("Your Bills")
                .font(.title)

            List(billviewmodel.bills, id: \.id) { bill in
                       VStack(alignment: .leading) {
                                Text("Hospital Name: \(bill.hospitalName)")
                                Text("Billing Date: \(formattedDate(date: bill.billingDate))")
                                Text("Total Amount Due: \(bill.totalAmountDue ?? 0)")
                           ForEach(bill.items, id: \.id) { item in // Corrected ForEach loop
                                       HStack {
                                           Text(item.description)
                                           Spacer()
                                           Text("Quantity: \(item.quantity ?? 1)")
                                           Text("Price/Service: \(item.pricePerService ?? 0)")
                                           Text("Total Charge: \(item.totalCharge ?? 0)")
                                       }
                                   }
                               
                                Text("Amount Paid: \(bill.amountPaid ?? 0)")
                                Text("Outstanding Balance: \(bill.outstandingBalance ?? 0)")
                                // Add more details as needed
                            }
                        }
        }
        .onAppear {
            billviewmodel.fetchBills(patientID: viewModel.currentUser?.id ?? "")
        }
    }
    func formattedDate(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }

    
}
