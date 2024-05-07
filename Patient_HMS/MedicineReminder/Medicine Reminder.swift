//
//  Medicine Reminder.swift
//  Patient_HMS
//
//  Created by Arnav on 07/05/24.
//

import Foundation
import SwiftUI



struct AddMedicineView: View {
    @EnvironmentObject var viewModel: Medicine_ViewModel
    @EnvironmentObject var authviewModel: AuthViewModel
    @State private var medicineName = ""
    @State private var dosage = ""
    @State private var selectedTimes: [String] = []
    @State private var selectedDaysOfWeek: [String] = [] // Selected days of the week
    @State private var startDate = Date()
    @State private var endDate = Date()

    @State private var showAlert = false // State variable to control the alert visibility
    @State private var alertMessage = "" // Message to display in the alert

    let times = ["Morning", "Afternoon", "Night"]
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var body: some View {
        VStack {
            TextField("Medicine Name", text: $medicineName)
            TextField("Dosage", text: $dosage)
            Form {
                Section(header: Text("Times")) {
                    ForEach(times, id: \.self) { time in
                        Toggle(time, isOn: self.binding(for: time, in: selectedTimes))
                    }
                }

                Section(header: Text("Days of the Week")) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Toggle(day, isOn: self.binding(for: day, in: selectedDaysOfWeek))
                    }
                }

                Section(header: Text("Start Date")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                }

                Section(header: Text("End Date")) {
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
            }
            Button("Save") {
                let medicine = Medicines(name: medicineName, dosage: dosage, times: selectedTimes, daysOfWeek: selectedDaysOfWeek, startDate: startDate, endDate: endDate)
                viewModel.addMedicine(medicine: medicine, userid: authviewModel.currentUser?.id ?? "")
                
                // Show success alert
                showAlert = true
                alertMessage = "Medicine added successfully"
                
                scheduleReminderNotification(for: medicine)
                clearFields()
                
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
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
    
    private func clearFields() {
        medicineName = ""
        dosage = ""
        selectedTimes.removeAll()
        selectedDaysOfWeek.removeAll()
        startDate = Date()
        endDate = Date()
    }
//    private func scheduleReminderNotification(for medicine: Medicines) {
//        let content = UNMutableNotificationContent()
//        content.title = "Medicine Reminder"
//        content.body = "Don't forget to take \(medicine.name) - \(medicine.dosage)"
//        content.sound = UNNotificationSound.default
//        
//        // Create a trigger to show the notification after 10 seconds
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
//
//        // Create a unique identifier for the notification
//        let identifier = UUID().uuidString
//        
//        // Create the notification request
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        
//        // Add the notification request to the notification center
//        UNUserNotificationCenter.current().add(request)
//    }

    
    private func scheduleReminderNotification(for medicine: Medicines) {
        let notificationHandler = NotificationHandler() // Initialize NotificationHandler
        
        let content = UNMutableNotificationContent()
        content.title = "Medicine Reminder"
        content.body = "Don't forget to take \(medicine.name) - \(medicine.dosage)"
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        for time in medicine.times {
            for dayOfWeek in medicine.daysOfWeek {
                // Calculate the next occurrence of the day of the week
                guard let nextDate = calendar.nextDate(after: currentDate, matching: DateComponents(weekday: daysOfWeek.firstIndex(of: dayOfWeek)! + 1), matchingPolicy: .nextTime) else {
                    continue
                }
                
                var triggerComponents = calendar.dateComponents([.year, .month, .day], from: nextDate)
                
                // Set the hour for the selected time
                switch time {
                case "Morning":
                    triggerComponents.hour = 8
                case "Afternoon":
                    triggerComponents.hour = 12
                case "Night":
                    triggerComponents.hour = 20
                default:
                    break
                }
                
                // Create the notification trigger
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
                
                // Create a unique identifier for each notification
                let identifier = "\(medicine.id ?? "")_\(dayOfWeek)_\(time)"
                
                // Create the notification request
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                // Schedule the notification using NotificationHandler
                notificationHandler.sendNotification(date: nil, timeInterval: trigger.nextTriggerDate()!.timeIntervalSince(currentDate), title: content.title, subtitle: "", body: content.body)
            }
        }
    }

}




struct AddMedicineView_Previews: PreviewProvider {
    static var previews: some View {
        AddMedicineView()
    }
}

