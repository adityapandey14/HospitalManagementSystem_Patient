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
    @State private var searchText = ""
    
    var filteredMedicines: [Medicines] {
        if searchText.isEmpty {
            return medicines
        } else {
            return medicines.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "e8f2fd"), Color(hex: "ffffff")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    HStack {
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .padding(.leading, 7)
                                TextField("Search Medicine", text: $searchText)
                                    .cornerRadius(10)
                                    .padding(10)
                                    .padding(.leading)
                                    .background(Color.elavated)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .frame(maxWidth: .infinity)
                                
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Text("Clear")
                                }
                                .padding(.trailing, 9)
                            }
                            .frame(height: 50)
                            .background(Color.white)
                            .foregroundColor(Color.gray)
                            .padding(20)
                            .frame(width: 340)
                        }
                        NavigationLink(destination: AddMedicineView(), isActive: $isAddingMedicine) {
                            Button {
                                isAddingMedicine = true
                            } label : {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(Color.black)
                            }
                            .padding(.trailing)
                        }
                    }
                    
                    if filteredMedicines.isEmpty {
                        Text("No Medicines")
                    } else {
                        List {
                            ForEach(filteredMedicines, id: \.id) { medicine in
                                VStack(alignment: .leading) {
                                    Text("\(medicine.name) ")
                                        .font(.headline)
                                    Text("\(medicine.dosage) \(medicine.times.joined(separator: ", "))")
                                }
                                .onTapGesture {
                                    self.selectedMedicine = medicine
                                }
                                .contextMenu {
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
                }
                .padding(.horizontal)
            }
            .sheet(item: $selectedMedicine) { medicine in
                EditMedicineView(medicine: medicine)
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
