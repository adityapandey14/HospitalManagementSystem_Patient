//
//  BillsView.swift
//  Patient_HMS
//
//  Created by Arnav on 09/05/24.
//

//import Foundation
//import SwiftUI
//
//struct BillsView: View {
//    @EnvironmentObject var billviewmodel:BillViewModel
//    @EnvironmentObject var viewModel:AuthViewModel
//
//
//    var body: some View {
//        VStack {
//            Text("Your Bills")
//                .font(.title)
//
//            List(billviewmodel.bills, id: \.id) { bill in
//                       VStack(alignment: .leading) {
//                                Text("Hospital Name: \(bill.hospitalName)")
//                                Text("Billing Date: \(formattedDate(date: bill.billingDate))")
//                                Text("Total Amount Due: \(bill.totalAmountDue ?? 0)")
//                           ForEach(bill.items, id: \.id) { item in // Corrected ForEach loop
//                                       HStack {
//                                           Text(item.description)
//                                           Spacer()
//                                           Text("Quantity: \(item.quantity ?? 1)")
//                                           Text("Price/Service: \(item.pricePerService ?? 0)")
//                                           Text("Total Charge: \(item.totalCharge ?? 0)")
//                                       }
//                                   }
//                               
//                                Text("Amount Paid: \(bill.amountPaid ?? 0)")
//                                Text("Outstanding Balance: \(bill.outstandingBalance ?? 0)")
//                                // Add more details as needed
//                            }
//                        }
//        }
//        .onAppear {
//            billviewmodel.fetchBills(patientID: viewModel.currentUser?.id ?? "")
//        }
//    }
//    func formattedDate(date: Date) -> String {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "MMM d, yyyy"
//            return formatter.string(from: date)
//        }
//
//    
//}

import Foundation
import SwiftUI

struct BillsView: View {
    @EnvironmentObject var billviewmodel:BillViewModel
    @EnvironmentObject var viewModel:AuthViewModel

    var body: some View {
        NavigationStack {
            List(billviewmodel.bills, id: \.id) { bill in
                BillCardView(bill: bill)
            }
            .navigationTitle("Your Bills")
            .onAppear {
                billviewmodel.fetchBills(patientID: viewModel.currentUser?.id ?? "")
            }
        }
    }
}

struct BillCardView: View {
    let bill: Bill
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hospital Name: \(bill.hospitalName)")
                .font(.headline)
            Text("Billing Date: \(formattedDate(date: bill.billingDate))")
                .font(.subheadline)
                .foregroundColor(.gray)
//            Text("Total Amount Due: \(bill.totalAmountDue ?? 0)")
//                .font(.subheadline)
//                .foregroundColor(.red)
            ForEach(bill.items, id: \.id) { item in
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.description)
                    Text("Quantity: \(item.quantity ?? 1)")
                    Text("Price/Service: \(String(format: "%.2f", item.pricePerService ?? 0))")
                    Text("Total Charge: \(String(format: "%.2f", item.totalCharge ?? 0))")
                }
                .font(.subheadline)
            }
//            Text("Amount Paid: \(bill.amountPaid ?? 0)")
//                .font(.subheadline)
//                .foregroundColor(.green)
//            Text("Outstanding Balance: \(bill.outstandingBalance ?? 0)")
//                .font(.subheadline)
//                .foregroundColor(.red)
        }
        .padding()
        .cornerRadius(10)
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

