//
//  MedicineView.swift
//  Patient_HMS
//
//  Created by Arnav on 07/05/24.
//

import Foundation
import Foundation
import SwiftUI
import SwiftUI

struct MedicineView: View {
    @EnvironmentObject var viewModel: Medicine_ViewModel
    @EnvironmentObject var authviewModel: AuthViewModel
    @State private var medicines: [Medicines] = []
    @State private var isAddingMedicine = false // New state variable for navigation
    @State private var selectedMedicine: Medicines? // State variable to store the selected medicine for editing
    let notificationHandler = NotificationHandler()
    
    var body: some View {
        NavigationView {
            VStack {
                if medicines.isEmpty {
                    Text("No Medicines")
                } else {
                    List {
                        ForEach(medicines, id: \.id) { medicine in
                            VStack(alignment: .leading) {
                                Text("Name: \(medicine.name)")
                                    .font(.headline)
                                Text("Dosage: \(medicine.dosage)")
                                Text("Times: \(medicine.times.joined(separator: ", "))")
                                Text("Days of Week: \(medicine.daysOfWeek.joined(separator: ", "))") // Display days of week
                                Text("Start Date: \(medicine.startDate)") // Display start date
                                Text("End Date: \(medicine.endDate)") // Display end date
                            }
                            .contextMenu {
                                Button("Edit") {
                                    self.selectedMedicine = medicine
                                }
                                Button("Delete") {
                                    
                                    viewModel.deleteMedicine(medicineID: medicine.id ?? "", userid: authviewModel.currentUser?.id ?? "")
                                    viewModel.getAllMedicines(userid: authviewModel.currentUser?.id ?? "") { medicines in
                                        self.medicines = medicines
                                    }
                                }
                            }
                        }
                    }
                }
                NavigationLink(destination: AddMedicineView(), isActive: $isAddingMedicine) {
                    Text("Add Medicine")
                }
            }
            .onAppear {
                notificationHandler.askPermission()
                viewModel.getAllMedicines(userid: authviewModel.currentUser?.id ?? "") { medicines in
                    self.medicines = medicines
                }
            }
            .navigationBarTitle("Medicine Reminder")
        }
    }
}
