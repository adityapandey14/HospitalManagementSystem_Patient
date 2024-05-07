//
//  ChiduMedicineView.swift
//  Patient_HMS
//
//  Created by ChiduAnush on 07/05/24.
//

import Foundation
import SwiftUI

struct ChiduMedicineView: View {
    
    @State private var searchText = ""
    @State private var isAddingMedicine = false
    var filteredMedicines: [Medicines] {
        if searchText.isEmpty {
            return medicines
        } else {
            return medicines.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    @State private var medicines: [Medicines] = []
    @EnvironmentObject var viewModel: Medicine_ViewModel
    @EnvironmentObject var authviewModel: AuthViewModel
    @State private var selectedMedicine: Medicines?
    let notificationHandler = NotificationHandler()
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                //top search and add medicine button
                HStack {
                    HStack(spacing: 15) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .opacity(0.7)
                        TextField("Search Medicine", text: $searchText)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    NavigationLink(destination: AddMedicineView(),isActive: $isAddingMedicine) {
                        Button(action: {
                            isAddingMedicine = true
                        }, label: {
                            Image(systemName: "plus")
                                .foregroundStyle(Color.white)
                                .font(.system(size: 25))
                        })
                    }
                    .padding()
                    .background(Color.accentBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Text("Tap on plus to Add new Medicine")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                
                
                
                //show search results if any, otherwise nill.
                if filteredMedicines.isEmpty {
                    Text("No Medicines added.")
                        .padding(.vertical)
                } else {
                    List {
                        ForEach(filteredMedicines, id: \.id) { medicine in
                            Section {
                                HStack(spacing: 20) {
                                    Image("iconTablet")
                                    VStack(alignment: .leading) {
                                        Text("\(medicine.name) ")
                                            .font(.system(size: 17))
                                        Text("\(medicine.dosage) \(medicine.times.joined(separator: ", "))")
                                            .font(.system(size: 14))
                                            .foregroundStyle(Color.accentBlue)
                                    }
                                    Spacer()
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 18))
                                        .foregroundStyle(Color.secondary)
                                }

                            }
                            .listRowBackground(Color(uiColor: .secondarySystemBackground))
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
                    .scrollContentBackground(.hidden)
                    .background(Color(uiColor: .systemBackground))
                    
                }
                
            }
            .padding()
            .sheet(item: $selectedMedicine) { medicine in
                EditMedicineView(medicine: medicine)
            }
            .onAppear{
                notificationHandler.askPermission()
                viewModel.getAllMedicines(userid: authviewModel.currentUser?.id ?? "") { medicines in
                    self.medicines = medicines
                }
            }
            .navigationTitle("Medicine Reminders")
            
            
        }
        
    }
}

#Preview {
    ChiduMedicineView()
}
