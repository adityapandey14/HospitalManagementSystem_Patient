//
//  ChiduHomepage.swift
//  Patient_HMS
//
//  Created by ChiduAnush on 07/05/24.
//

import SwiftUI
import HealthKit
import FirebaseAuth

struct ChiduHomepage: View {
    @EnvironmentObject var medviewModel: Medicine_ViewModel
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var medicines: [Medicines] = []
    @ObservedObject var appointViewModel = AppointmentViewModel()
    @State private var greeting: String = ""
    
    @State private var isVitalsExpanded = true
    let currentUserId = Auth.auth().currentUser?.uid
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var profileViewModel:PatientViewModel
    
    var body: some View {
        
        
        NavigationStack {
            
            ScrollView {
                
                //logo, (goodmorning, name), vitals button.
                HStack(spacing: 10){
                    Image( colorScheme == .dark ? "homePageLogoBlue" : "mednexLogoSmall")
                    VStack(alignment: .leading) {
                        Text(greeting)
                            .font(.system(size: 19))
                            .onAppear {
                                updateGreeting()
                            }
                        Text(profileViewModel.currentProfile.fullName )
                            .foregroundStyle(Color("accentBlue"))
                            .font(.system(size: 19))
                    }
                    Spacer()
                    Button(action: {
//                            withAnimation {
//                                isVitalsExpanded.toggle()
//                            }
                    }, label: {
//                        Image(systemName: "doc.text.below.ecg")
                        Image(systemName: "doc.text")
                            .foregroundStyle(Color.accentBlue)
                            .font(.title)
                    })
                    
                    
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                
                
                
                if isVitalsExpanded {
                    VStack {
                      Vital()
                            .padding()
                    }
//                    .transition(.move(edge: .top))
                    .animation(.easeInOut)
                }
                
                //upcoming Appointments
                HStack {
                    Text("Upcoming Appointments")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                    Spacer()
                }
                .padding(.top, isVitalsExpanded ? 0 : 30)
                .padding(.horizontal)
//                .padding(.bottom)
                ScrollView(.horizontal, showsIndicators: false){
                    HStack() {
                        
                        LazyHStack(spacing: -15) {
                            ForEach(appointViewModel.appointments.filter {
                                                          (  $0.patientID == currentUserId) && (Date() <= returnInDate(dateTime: $0.date, timeString: $0.timeSlot))
                                                        }) { appointment in
                                HStack(alignment: .center) {
                                    AppointmentCard(appointment: appointment)
                                } //End of Horizontal Stack
                            }
                        }
//                        HStack {
//                            VStack(alignment: .leading, spacing: 20){
//                                VStack(alignment: .leading, spacing: 6) {
//                                    Text("Dr. Lorem Ipsum")
//                                        .font(.system(size: 17))
//                                    Text("Cardiologist")
//                                        .font(.system(size: 15))
//                                        .foregroundStyle(Color("accentBlue"))
//                                }
//                                
//                                VStack(spacing: 10){
//                                    HStack(spacing: 10) {
//                                        Image(systemName: "calendar")
//                                            .font(.system(size: 21))
//                                        Text("24th April 2024")
//                                        Spacer()
//                                    }
//                                    HStack(spacing: 10){
//                                        Image(systemName: "clock")
//                                            .font(.system(size: 21))
//                                        Text("02:30 PM - 03:00 PM")
//                                        Spacer()
//                                    }
//                                }
//                            }
//                        }
//                        .padding()
//                        .frame(minWidth: 320)
//                        .background(Color(uiColor: .secondarySystemBackground))
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .padding(.horizontal)
                    }
                }
                .onAppear {
//                    let date = Date()
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "MMM, yyyy"
//                    currentDateMonth = dateFormatter.string(from: date)
//                    getDaysOfWeek()
                    appointViewModel.fetchAppointments() // Fetch appointments when the view appears
                }
                
//                HStack {
//                    Text("My Apointments")
//                        .font(.system(size: 17))
//                        .foregroundStyle(Color(uiColor: .secondaryLabel))
//                    Spacer()
//                    NavigationLink(destination: AppointmentView()) {
//                        Image(systemName: "chevron.right")
//                    }
//                }
//                .padding(.top, 35)
//                .padding(.horizontal)
//                .padding(.bottom, 10)
                
                //Today's Medicines
                HStack {
                    Text("Today's Medicines")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                    Spacer()
                    NavigationLink {
                        ChiduMedicineView()
                    } label: {
                        Text("View All")
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.asparagus)
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal)
//                .padding(.bottom)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(medicines) { medicine in
                            MedicineCardView(medicine: medicine)
                        }
                    }
                }
                .padding(.horizontal)
                .onAppear {
                    let userId = Auth.auth().currentUser?.uid
                    medviewModel.getTodayMedicines(userid: userId!){
                        medicines in
                        self.medicines = medicines
                    }
                }
                
                
                //Common Concerns
                HStack {
                    Text("Common Concerns")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.horizontal)
//                .padding(.bottom)
                HStack(spacing: 20) {
                    VStack {
                        ZStack {
                            Circle()
                                .frame(width: 42, height: 42)
                                .foregroundStyle(Color("accentBlue"))
                                .opacity(0.2)
                            Image("cough")
                                .resizable()
                                .frame(width:25, height: 25)
                                .opacity(0.8)
                        }
                        Text("Cough, cold\nFever")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 11))
                            .opacity(0.8)
                    }
                    VStack {
                        ZStack {
                            Circle()
                                .frame(width: 42, height: 42)
                                .foregroundStyle(Color("accentBlue"))
                                .opacity(0.2)
                            Image("person")
                                .resizable()
                                .frame(width:25, height: 25)
                                .opacity(0.8)
                        }
                        Text("Child\n unwell")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 11))
                            .opacity(0.8)
                    }
                    VStack {
                        ZStack {
                            Circle()
                                .frame(width: 42, height: 42)
                                .foregroundStyle(Color("accentBlue"))
                                .opacity(0.2)
                            Image("depressed")
                                .resizable()
                                .frame(width:25, height: 25)
                                .opacity(0.8)
                        }
                        Text("Depression\nor Anxiety")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 11))
                            .opacity(0.8)
                    }
                    VStack {
                        ZStack {
                            Circle()
                                .frame(width: 42, height: 42)
                                .foregroundStyle(Color("accentBlue"))
                                .opacity(0.2)
                            Image("dermatology")
                                .resizable()
                                .frame(width:25, height: 25)
                                .opacity(0.8)
                        }
                        Text("Acne &\nPimples")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 11))
                            .opacity(0.8)
                    }
                    VStack {
                        ZStack {
                            Circle()
                                .frame(width: 42, height: 42)
                                .foregroundStyle(Color("accentBlue"))
                                .opacity(0.2)
                            Image("woman")
                                .resizable()
                                .frame(width:25, height: 25)
                                .opacity(0.8)
                        }
                        Text("Period\nProblems")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 11))
                            .opacity(0.8)
                    }
                }
            }
            
            
            
        }
        .onAppear(){
            profileViewModel.fetchProfile(userId: Auth.auth().currentUser?.uid)
            
            
        }
        
    }
    private func updateGreeting() {
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            print(hour)
            if hour >= 6 && hour < 12 {
                greeting = "Good Morning"
            } else if hour >= 12 && hour < 17 {
                greeting = "Good Afternoon"
            } else if hour >= 17 && hour < 22 {
                greeting = "Good Evening"
            } else {
                greeting = "Time to sleep"
            }
        }
}




struct Vital: View {
    @State private var currentTime = Date()
    @State private var isVitalsExpanded = true
    
    @State private var heartRate: Double?
    @State private var bloodOxygen: Double?
    @State private var steps: Double?
    @State private var sleepHours: Double?
    
    let healthStore = HKHealthStore()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
         //       headerView
                
//                if isVitalsExpanded {
                 vitalsView
//                        .transition(.slide)
//                } else {
//                    // Content to display when vitals are not expanded
//                    emptyView
//                }
                
//                Spacer()
            }
//            .background(
////                LinearGradient(gradient: Gradient(colors: [Color(hex: "e8f2fd"), Color(hex: "ffffff")]), startPoint: .top, endPoint: .bottom)
////                    .edgesIgnoringSafeArea(.all)
//                Color("solitude")
//            )
        }
        .onAppear {
            requestAuthorization()
        }
    }
    
//    private var headerView: some View {
////        HStack {
////            Image(systemName: "heart.text.square")
////                .font(.title)
////                .foregroundColor(.red)
////
//////            Text(greeting())
//////                .font(.title2)
//////                .fontWeight(.bold)
////
////            Spacer()
//////
//////            Button(action: {
//////                withAnimation {
//////                    isVitalsExpanded.toggle()
//////                }
//////                fetchHealthData()
//////            }) {
//////                Image(systemName: "waveform.path.ecg")
//////                    .font(.title)
//////                    .foregroundColor(isVitalsExpanded ? .red : .blue)
//////            }
////        }
//    }


    
    private var vitalsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your vitals")
                .font(.system(size: 17))
                .foregroundStyle(Color(uiColor: .secondaryLabel))
            HStack {
                HealthDataView(imageName: "heart.fill", value: heartRate ?? 0, unit: "bpm", imageColor: .red)
                HealthDataView(imageName: "waveform.path.ecg", value: bloodOxygen ?? 0, unit: "%", imageColor: .blue)
                HealthDataView(imageName: "powersleep", value: steps ?? 0, unit: "", imageColor: .purple)
                HealthDataView(imageName: "figure.walk", value: sleepHours ?? 0, unit: "hrs", imageColor: .green)
            }
            .padding(.vertical)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
//            Spacer()
        }
    }

//    private var emptyView: some View {
//        VStack {
//            Text("Expand to view vitals")
//                .font(.headline)
//                .foregroundColor(.gray)
//            
//            Spacer()
//        }
//    }
    
    
    
    private func requestAuthorization() {
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            if !success {
                print("Error requesting HealthKit authorization: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    private func fetchHealthData() {
        fetchHeartRate()
        fetchBloodOxygen()
        fetchSteps()
        fetchSleepHours()
    }
    
    private func fetchHeartRate() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let query = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: nil, options: .discreteAverage) { (_, result, error) in
            guard let result = result, let average = result.averageQuantity() else {
                print("Error fetching heart rate: \(error?.localizedDescription ?? "")")
                return
            }
            DispatchQueue.main.async {
                self.heartRate = average.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
            }
        }
        healthStore.execute(query)
    }
    
    private func fetchBloodOxygen() {
        let bloodOxygenType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!
        let query = HKStatisticsQuery(quantityType: bloodOxygenType, quantitySamplePredicate: nil, options: .discreteAverage) { (_, result, error) in
            guard let result = result, let average = result.averageQuantity() else {
                print("Error fetching blood oxygen: \(error?.localizedDescription ?? "")")
                return
            }
            DispatchQueue.main.async {
                self.bloodOxygen = average.doubleValue(for: HKUnit.percent())
            }
        }
        healthStore.execute(query)
    }
    
    private func fetchSteps() {
        let stepsType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let query = HKStatisticsQuery(quantityType: stepsType, quantitySamplePredicate: nil, options: .cumulativeSum) { (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Error fetching steps count: \(error?.localizedDescription ?? "")")
                return
            }
            DispatchQueue.main.async {
                self.steps = sum.doubleValue(for: HKUnit.count())
            }
        }
        healthStore.execute(query)
    }
    
    private func fetchSleepHours() {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (_, samples, error) in
            guard let samples = samples as? [HKCategorySample] else {
                print("Error fetching sleep data: \(error?.localizedDescription ?? "")")
                return
            }
            let totalSleepHours = samples.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
            DispatchQueue.main.async {
                self.sleepHours = totalSleepHours / 3600 // Convert seconds to hours
            }
        }
        healthStore.execute(query)
    }
}

struct MedicineCardView: View {
    let medicine: Medicines // Assuming Medicine is your model

    var body: some View {
        HStack(spacing: 15) {
            Image("iconTablet") // Assuming you have an image asset named "iconTablet"
            VStack(alignment: .leading) {
                Text(medicine.name)
                    .font(.system(size: 15))
                Text(medicine.dosage)
                    .font(.system(size: 13))
                    .foregroundStyle(Color("accentBlue")) // Assuming you have a color named "accentBlue"
            }
            Spacer()
        }
        .frame(width: 180)
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
        
    }
}

//#Preview {
//    ChiduHomepage()
//        .environmentObject(PatientViewModel())
//        .environmentObject(AuthViewModel())
//        .environmentObject(Medicine_ViewModel())
//}


struct AppointmentCard: View {
    let appointment: AppointmentModel
    @StateObject var doctorViewModel = DoctorViewModel.shared
    @State private var doctorName: String = "Unknown"
    
    var body: some View {
        
        
        HStack {
            VStack(alignment: .leading, spacing: 20){
                VStack(alignment: .leading, spacing: 6) {
                    if let doctor = doctorViewModel.doctorDetails.first(where: { $0.id == appointment.doctorID }) {
                        HStack(spacing: 10){
                            if let imageUrl = URL(string: doctor.profilephoto ?? "userphoto") {
                                AsyncImage(url: imageUrl) { image in
                                    image
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                } placeholder: {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                    
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            } else {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 3){
                                Text(doctor.fullName)
                                    .font(.system(size: 18))
                                Text(doctor.department)
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color("accentBlue"))
                                Spacer()
                            }
                            .padding(.top, 5)
                        }

                    } else {
                        Text("Loading...")
                            .font(.system(size: 18))
                            .onAppear {
                                Task {
                                    await doctorViewModel.fetchDoctorDetailsByID(doctorID: appointment.patientID)
                            }
                        }
                    }
                }
                
                HStack {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundStyle(Color.accentBlue)
                            .font(.system(size: 18))
                        Text(appointment.date)
                            .font(.system(size: 15))
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(Color.accentBlue)
                            .font(.system(size: 18))
                        Text(appointment.timeSlot)
                            .font(.system(size: 15))
                    }
                }
                .padding()
                .background(Color.accentBlue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
//                VStack(spacing: 10){
//                    HStack(spacing: 10) {
//                        Image(systemName: "calendar")
//                            .font(.system(size: 21))
//                        Text(appointment.date)
//                            .font(.system(size: 15))
//                        Spacer()
//                    }
//                    HStack(spacing: 10){
//                        Image(systemName: "clock")
//                            .font(.system(size: 21))
//                        Text(appointment.timeSlot)
//                            .font(.system(size: 15))
//                        Spacer()
//                    }
//                }
            }
        }
        .padding()
        .frame(minWidth: 320)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
    
    func calculateAge(from dob: Date) -> String {
        let now = Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year, .month, .day, .hour], from: dob, to: now)
        
        if let years = ageComponents.year, years > 0 {
            return "\(years) year\(years == 1 ? "" : "s")"
        } else if let months = ageComponents.month, months > 0 {
            return "\(months) month\(months == 1 ? "" : "s")"
        } else if let days = ageComponents.day, days > 0 {
            return "\(days) day\(days == 1 ? "" : "s")"
        } else if let hours = ageComponents.hour, hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s")"
        } else {
            return "0"
        }
    }
}

func returnInDate(dateTime: String, timeString: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy h:mm a" // Adjusted date format to match the incoming format
    
    let finalDate = "\(dateTime) \(timeString)"
    return dateFormatter.date(from: finalDate) ?? Date()
}
