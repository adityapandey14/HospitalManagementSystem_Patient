//
//  SlotBooking.swift
//  Patient_HMS
//
//  Created by Arnav on 30/04/24.
//


import SwiftUI
import Firebase

struct TimeButton: View {
    var time: String
    var bookedSlots: [String]
    @Binding var selectedSlot: String?
   
    var body: some View {
        let isBooked = bookedSlots.contains(time)
        let isSelected = selectedSlot == time
        let isSelectable = !isBooked
        
        Button(action: {
            // Update selected time slot if it is selectable
            if isSelectable {
                selectedSlot = time
            }
        }) {
            RoundedRectangle(cornerRadius: 15)
                .fill(isBooked ? Color.white : (isSelected ? Color.blue : Color.white)) // Fill color based on booking and selection status
                .overlay(
                    Text(time)
                        .font(.headline)
                        .foregroundColor(isBooked ? .gray : (isSelected ? .white : .blue)) // Set text color based on selection and availability
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isBooked ? Color.gray : Color.blue, lineWidth: 1) // Set border color based on booking status
                )
                .opacity(isBooked ? 0.5 : 1.0) // Reduce opacity if booked
                .disabled(isBooked) // Disable button if booked
        }
        .frame(width: 90, height: 50)
    }
}


struct SlotBookView: View {
    @EnvironmentObject var userTypeManager: UserTypeManager
    
    let doctor: DoctorModel
    let gridItems = Array(repeating: GridItem(.flexible()), count: 3)
    let times = ["9:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00"]
    
    
    @State private var selectedSlotIndex: Int? = nil // Track selected slot index
    
    @State private var bookedSlots: [String] = [] // Initialize as empty
    @State private var selectedSlot: String? = nil
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(1), Color.blue.opacity(0.5)]),
                        startPoint: .leading,
                        endPoint: .trailing))
                    .frame(width: 361, height: 180)
                    .shadow(color: Color.black.opacity(0.15), radius: 20)
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(doctor.name)
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .frame(alignment: .top)
                        
                        Text(doctor.specialisation)
                            .font(.callout)
                            .foregroundColor(.white)
                        
                        Text(doctor.degree)
                            .font(.body)
                            .foregroundColor(.white)
                        Text("Experience: \(doctor.experience) years")
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 60))
                        .padding(.trailing, 10)
                }
                .padding(.leading, 30)
                Spacer()
            }
            .frame(width: 380, height: 200)
            Text("Appointment Date")
                .font(.headline)
            
            ZStack {
                RoundedRectangle(cornerRadius: 11)
                    .fill(Color(hex: "f5f5f5"))
                    .frame(width: 360, height: 70)
                
                DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding()
                
                
            }
            
            Text("Select a Slot")
                .font(.headline)
            
            ZStack {
                RoundedRectangle(cornerRadius: 11)
                    .fill(Color(hex: "f5f5f5"))
                    .frame(width: 360, height: 200)
                
                LazyVGrid(columns: gridItems, spacing: 10) {
                    ForEach(times, id: \.self) { time in
                        TimeButton(time: time, bookedSlots: bookedSlots, selectedSlot: $selectedSlot)
                    }
                }                .padding()
            }
            Button(action: {
                // Action to perform when the button is tapped
                print(selectedDate.formatted(date: .numeric, time: .omitted) , selectedSlot!)
                
                guard let slot = selectedSlot else { return }
                
                createBooking(for: doctor, on: selectedDate, at: slot)
                
            }) {
                // Button label
                Text("Book Slot")
                    .font(.title3.bold())
                    .padding() // Add padding around the text
                    .foregroundColor(.white) // Set text color
                    .background(Color.blue) // Set background color
                    .cornerRadius(20) // Apply corner radius to create rounded corners
                    .frame(width: 200,height: 100)
            }
            .disabled(selectedSlot == nil)
        }
        .onAppear {
            fetchAppointments()
        }
        .onChange(of: selectedDate) { _ in
            fetchAppointments()
        }
    }
    
    
    func fetchAppointments() {
        let db = Firestore.firestore()
        let appointmentsRef = db.collection("appointments")
        let formattedDate = selectedDate.formatted(date: .numeric, time: .omitted)
        
        appointmentsRef
            .whereField("DocID", isEqualTo: doctor.employeeID)
            .whereField("Date", isEqualTo: formattedDate)
            .getDocuments {(querySnapshot, error) in
                if let error = error {
                    print("Error getting appointments: \(error.localizedDescription)")
                } else if let querySnapshot = querySnapshot {
                    // Clear out the old booked slots
                    bookedSlots.removeAll()
                    let slots = querySnapshot.documents.compactMap { $0.data()["TimeSlot"] as? String }
                    
                    DispatchQueue.main.async {
                        bookedSlots = slots
                    }
                }
            }
    }
    
    func createBooking(for doctor: DoctorModel, on date: Date, at slot: String) {
            let db = Firestore.firestore()
            let appointmentsRef = db.collection("appointments")

            let appointmentData: [String: Any] = [
                "Bill": 1000,
                "Date": date.formatted(date: .numeric, time: .omitted),
                "DocID": doctor.employeeID,
                "PatID": userTypeManager.userID,
                "TimeSlot": slot,
                "isComplete": false,
                "reason": "Fever"
            ]

            appointmentsRef.addDocument(data: appointmentData) { error in
                if let error = error {
                    print("Error creating booking: \(error.localizedDescription)")
                } else {
                    print("Booking created successfully")
                }
            }
        }
    
}

struct SlotBookView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyDoctor = DoctorModel(
            id: "1",
            name: "Dr. Jane Doe",
            department: "Cardiology",
            email: "jane.doe@example.com",
            contact: "1234567890",
            experience: "10",
            employeeID: "D0001",
            image: nil,
            specialisation: "Cardiologist",
            degree: "MD",
            cabinNumber: "101"
        )
        
        SlotBookView(doctor: dummyDoctor)
    }
}


extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
