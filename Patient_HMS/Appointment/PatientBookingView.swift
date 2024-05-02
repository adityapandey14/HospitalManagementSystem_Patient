//
//  PatientBookingView.swift
//  Patient_HMS
//
//  Created by Aditya Pandey on 02/05/24.
//

import SwiftUI
import Combine
import Firebase
import FirebaseFirestore

// Appointment model to represent the data from Firebase
struct AppointmentModel: Identifiable {
    var id: String
    var date: String
    var doctorID: String
    var patientID: String
    var timeSlot: String
    var isComplete: Bool
    var reason: String
}

// Observable object to manage data fetching and state
class AppointmentViewModel: ObservableObject {
    @Published var appointments: [AppointmentModel] = []
    @Published var errorMessage: String? = nil
    
    private var db = Firestore.firestore()
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchAppointments() {
        db.collection("appointments").getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                self?.errorMessage = "Error fetching data: \(error.localizedDescription)"
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                self?.errorMessage = "No data found"
                return
            }
            
            self?.appointments = documents.compactMap { doc -> AppointmentModel? in
                let data = doc.data()
                return AppointmentModel(
                    id: doc.documentID,
                    date: data["Date"] as? String ?? "",
                    doctorID: data["DoctorID"] as? String ?? "",
                    patientID: data["PatientID"] as? String ?? "",
                    timeSlot: data["TimeSlot"] as? String ?? "",
                    isComplete: data["isComplete"] as? Bool ?? false,
                    reason: data["reason"] as? String ?? ""
                )
            }
        }
    }
}





struct AppointmentListView: View {
    @ObservedObject var viewModel = AppointmentViewModel()
    let currentUserID: String // This will be the current user's UID

    var body: some View {
        NavigationView {
            List {
                // Display the appointments for the current user
                ForEach(viewModel.appointments.filter { $0.patientID == currentUserID }) { appointment in
                    VStack(alignment: .leading) {
                        Text("Date: \(appointment.date)")
                        Text("Time Slot: \(appointment.timeSlot)")
                        Text("Doctor ID: \(appointment.doctorID)")
                        Text("Reason: \(appointment.reason)")
                        if appointment.isComplete {
                            Text("Status: Complete")
                                .foregroundColor(.green)
                        } else {
                            Text("Status: Incomplete")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("My Appointments")
            .onAppear {
                viewModel.fetchAppointments() // Fetch data when the view appears
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct appointView: View {
    var body: some View {
        // Assume we have a way to get the current user's UID from Firebase Auth
        if let currentUserUID = Auth.auth().currentUser?.uid {
            AppointmentListView(currentUserID: currentUserUID)
        } else {
            Text("User not authenticated.")
        }
    }
}

struct appointView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
