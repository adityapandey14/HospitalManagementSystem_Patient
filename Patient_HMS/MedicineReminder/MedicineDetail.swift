//
//  MedicineDetail.swift
//  Patient_HMS
//
//  Created by admin on 07/05/24.
//

import Foundation
import SwiftUI
struct EditMedicineView: View {
    @EnvironmentObject var viewModel: Medicine_ViewModel
    @EnvironmentObject var authviewModel: AuthViewModel
    @State private var medicineName: String
    @State private var dosage: String
    @State private var selectedTimes: [String]
    @State private var selectedDaysOfWeek: [String]
    @State private var startDate: Date
    @State private var endDate: Date

    let times = ["Morning", "Afternoon", "Night"]
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    init(medicine: Medicines) {
        self._medicineName = State(initialValue: medicine.name)
        self._dosage = State(initialValue: medicine.dosage)
        self._selectedTimes = State(initialValue: medicine.times)
        self._selectedDaysOfWeek = State(initialValue: medicine.daysOfWeek)
        self._startDate = State(initialValue: medicine.startDate)
        self._endDate = State(initialValue: medicine.endDate)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medicine Details")) {
                    TextField("Medicine Name", text: $medicineName)
                    TextField("Dosage", text: $dosage)
                }

                Section(header: Text("Times")) {
                    ForEach(times, id: \.self) { time in
                        Toggle(time, isOn: self.binding(for: time, in: selectedTimes))
                    }
                }

                Section(header: Text("Days of the Week")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(daysOfWeek, id: \.self) { day in
                                DayButton(title: day, isSelected: self.selectedDaysOfWeek.contains(day)) {
                                    if self.selectedDaysOfWeek.contains(day) {
                                        self.selectedDaysOfWeek.removeAll { $0 == day }
                                    } else {
                                        self.selectedDaysOfWeek.append(day)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }

                Section(header: Text("Start Date")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                }

                Section(header: Text("End Date")) {
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }

                Button("Save Changes") {
                    let editedMedicine = Medicines(name: medicineName, dosage: dosage, times: selectedTimes, daysOfWeek: selectedDaysOfWeek, startDate: startDate, endDate: endDate)
                    // Update medicine in the view model
                    viewModel.updateMedicine(medicine: editedMedicine, userid: authviewModel.currentUser?.id ?? "")
                    // Go back to the previous view
                    // You may need to implement a way to navigate back to the previous view
                }
            }
            .navigationBarTitle("Edit Medicine")
        }
    }

    private func binding(for selection: String, in array: [String]) -> Binding<Bool> {
        Binding(
            get: { array.contains(selection) },
            set: { newValue in
                if newValue {
                    if self.times.contains(selection) {
                        self.selectedTimes.append(selection)
                    } else {
                        self.selectedDaysOfWeek.append(selection)
                    }
                } else {
                    if self.times.contains(selection) {
                        self.selectedTimes.removeAll { $0 == selection }
                    } else {
                        self.selectedDaysOfWeek.removeAll { $0 == selection }
                    }
                }
            }
        )
    }
}


//struct MedicineDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        MedicineDetail()
//    }
//}

//#Preview {
//    EditMedicineView(medicine: <#Medicines#>)
//        .environmentObject(Medicine_ViewModel())
//}
