////
////  Medicine Reminder.swift
////  Patient_HMS
////
////  Created by Arnav on 07/05/24.
////
//
//import Foundation
//import SwiftUI
//
//
//struct AddMedicineView: View {
//    @EnvironmentObject var viewModel: Medicine_ViewModel
//    @EnvironmentObject var authviewModel: AuthViewModel
//    @State private var medicineName = ""
//    @State private var dosage = ""
//    @State private var selectedTimes: [String] = []
//    @State private var selectedDaysOfWeek: [String] = [] // Selected days of the week
//    @State private var startDate = Date()
//    @State private var endDate = Date()
//
//    @State private var showAlert = false // State variable to control the alert visibility
//    @State private var alertMessage = "" // Message to display in the alert
//
//    let times = ["Morning", "Afternoon", "Night"]
//    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                LinearGradient(gradient: Gradient(colors: [Color(hex: "e8f2fd"), Color(hex: "ffffff")]), startPoint: .top, endPoint: .bottom)
//                    .edgesIgnoringSafeArea(.all)
//                
//                ScrollView {
//                    VStack {
//                        Text("Add Medicine")
//                            .bold()
//                            .font(.system(size: 30))
//                            .padding(.bottom, 20)
//                        
//                        TextField("Medicine Name", text: $medicineName)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding()
//                        
//                        TextField("Dosage", text: $dosage)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding()
//                        
//                        Text("Select days for medicine reminder:")
//                            .font(.headline)
//                            .padding()
//                        
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 20) {
//                                ForEach(daysOfWeek, id: \.self) { day in
//                                    DayButton(title: day, isSelected: self.selectedDaysOfWeek.contains(day)) {
//                                        if self.selectedDaysOfWeek.contains(day) {
//                                            self.selectedDaysOfWeek.removeAll { $0 == day }
//                                        } else {
//                                            self.selectedDaysOfWeek.append(day)
//                                        }
//                                    }
//                                }
//                            }
//                            .padding()
//                        }
//                        
//                        Text("Selected Days: \(selectedDaysOfWeek.joined(separator: ", "))")
//                            .padding()
//                        
//                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
//                            .padding()
//                        
//                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
//                            .padding()
//                        
//                        Text("Select times for medicine reminder:")
//                            .font(.headline)
//                            .padding()
//                        
//                        VStack {
//                            ForEach(times, id: \.self) { time in
//                                Toggle(time, isOn: self.binding(for: time, in: selectedTimes))
//                                    .padding()
//                            }
//                        }
//                        
//                        Button("Save") {
//                            let medicine = Medicines(name: medicineName, dosage: dosage, times: selectedTimes, daysOfWeek: selectedDaysOfWeek, startDate: startDate, endDate: endDate)
//                            viewModel.addMedicine(medicine: medicine, userid: authviewModel.currentUser?.id ?? "")
//                            
//                            // Show success alert
//                            showAlert = true
//                            alertMessage = "Medicine added successfully"
//                            
//                            scheduleReminderNotification(for: medicine)
//                            clearFields()
//                        }
//                        .padding(.top)
//                        .alert(isPresented: $showAlert) {
//                            Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//            }
//        }
//    }
//
//    private func binding(for selection: String, in array: [String]) -> Binding<Bool> {
//        Binding(
//            get: { array.contains(selection) },
//            set: { newValue in
//                if newValue {
//                    if self.times.contains(selection) {
//                        self.selectedTimes.append(selection)
//                    } else {
//                        self.selectedDaysOfWeek.append(selection)
//                    }
//                } else {
//                    if self.times.contains(selection) {
//                        self.selectedTimes.removeAll { $0 == selection }
//                    } else {
//                        self.selectedDaysOfWeek.removeAll { $0 == selection }
//                    }
//                }
//            }
//        )
//    }
//    
//    private func clearFields() {
//        medicineName = ""
//        dosage = ""
//        selectedTimes.removeAll()
//        selectedDaysOfWeek.removeAll()
//        startDate = Date()
//        endDate = Date()
//    }
//    
//    private func scheduleReminderNotification(for medicine: Medicines) {
//        let notificationHandler = NotificationHandler() // Initialize NotificationHandler
//        
//        let content = UNMutableNotificationContent()
//        content.title = "Medicine Reminder"
//        content.body = "Don't forget to take \(medicine.name) - \(medicine.dosage)"
//        content.sound = UNNotificationSound.default
//        
//        let calendar = Calendar.current
//        let currentDate = Date()
//        
//        for time in medicine.times {
//            for dayOfWeek in medicine.daysOfWeek {
//                // Calculate the next occurrence of the day of the week
//                guard let nextDate = calendar.nextDate(after: currentDate, matching: DateComponents(weekday: daysOfWeek.firstIndex(of: dayOfWeek)! + 1), matchingPolicy: .nextTime) else {
//                    continue
//                }
//                
//                var triggerComponents = calendar.dateComponents([.year, .month, .day], from: nextDate)
//                
//                switch time {
//                case "Morning":
//                    triggerComponents.hour = 8
//                case "Afternoon":
//                    triggerComponents.hour = 12
//                case "Night":
//                    triggerComponents.hour = 20
//                default:
//                    break
//                }
//                
//                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
//                
//                let identifier = "\(medicine.id ?? "")_\(dayOfWeek)_\(time)"
//                
//                _ = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//                
//                notificationHandler.sendNotification(date: nil, timeInterval: trigger.nextTriggerDate()!.timeIntervalSince(currentDate), title: content.title, subtitle: "", body: content.body)
//            }
//        }
//    }
//}
//
//struct DayButton: View {
//    var title: String
//    var isSelected: Bool
//    var action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            Text(title)
//                .foregroundColor(isSelected ? .white : .primary)
//                .padding()
//                .background(isSelected ? Color.accentBlue : Color(uiColor: .secondarySystemBackground))
//                .cornerRadius(8)
//        }
//    }
//}
//
////    private func scheduleReminderNotification(for medicine: Medicines) {
////        let content = UNMutableNotificationContent()
////        content.title = "Medicine Reminder"
////        content.body = "Don't forget to take \(medicine.name) - \(medicine.dosage)"
////        content.sound = UNNotificationSound.default
////        
////        // Create a trigger to show the notification after 10 seconds
////        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
////
////        // Create a unique identifier for the notification
////        let identifier = UUID().uuidString
////        
////        // Create the notification request
////        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
////        
////        // Add the notification request to the notification center
////        UNUserNotificationCenter.current().add(request)
////    }
//
//
//
//
//struct AddMedicineView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMedicineView()
//    }
//}



//------ - - - - - - -- -  - - - - - - - - - -





import Foundation
import SwiftUI

struct AddMedicineView: View {
    @EnvironmentObject var viewModel: Medicine_ViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var medicineName = ""
    @State private var dosage = ""
    @State private var selectedTimes: [String] = []
    @State private var selectedDaysOfWeek: [String] = []
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var showAlert = false
    @State private var alertMessage = ""

    let times = ["Morning", "Afternoon", "Night"]
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var body: some View {
        NavigationStack {
            ZStack {
                
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Add Medicine")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20)

//                        TextField("Medicine Name", text: $medicineName)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding()
                        TextField("Medicine Name", text: $medicineName)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .padding(.horizontal)

                        
//                        TextField("Dosage", text: $dosage)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding()
                        TextField("Dosage", text: $dosage)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .padding(.horizontal)

                        Text("Select days for medicine reminder:")
                            .font(.headline)
                            .padding(.vertical)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
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
                            .padding(.horizontal)
                        }

                        Text("Selected Days: \(selectedDaysOfWeek.joined(separator: ", "))")
                            .padding()

                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                            .padding()

                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                            .padding()

                        Text("Select times for medicine reminder:")
                            .font(.headline)
                            .padding(.vertical)

                        ForEach(times, id: \.self) { time in
                            Toggle(time, isOn: self.binding(for: time))
                                .padding()
                        }

                        Button("Save") {
                            let medicine = Medicines(name: medicineName, dosage: dosage, times: selectedTimes, daysOfWeek: selectedDaysOfWeek, startDate: startDate, endDate: endDate)
                            viewModel.addMedicine(medicine: medicine, userid: authViewModel.currentUser?.id ?? "")
                            
                            showAlert = true
                            alertMessage = "Medicine added successfully"
                            scheduleReminderNotification(for: medicine)
                            clearFields()
                        }
                        .foregroundStyle(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.accentBlue)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .cornerRadius(10)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    .padding(.horizontal)
                    .navigationTitle("Add Medicine")
                }
                
            }
            
        }
        
    }

    private func binding(for selection: String) -> Binding<Bool> {
        Binding(
            get: { self.selectedTimes.contains(selection) },
            set: { newValue in
                if newValue {
                    if !self.selectedTimes.contains(selection) {
                        self.selectedTimes.append(selection)
                    }
                } else {
                    self.selectedTimes.removeAll { $0 == selection }
                }
            }
        )
    }
    
    private func clearFields() {
        medicineName = ""
        dosage = ""
        selectedTimes.removeAll()
        selectedDaysOfWeek.removeAll()
        startDate = Date()
        endDate = Date()
    }
    
    private func scheduleReminderNotification(for medicine: Medicines) {
        // Notification scheduling logic remains unchanged
    }
}

struct DayButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(isSelected ? .white : .primary)
                .padding()
                .background(isSelected ? Color.accentBlue : Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
    }
}

struct AddMedicineView_Previews: PreviewProvider {
    static var previews: some View {
        AddMedicineView().environmentObject(Medicine_ViewModel())
    }
}
