////
////  Homepage.swift
////  Patient_HMS
////
////  Created by Aditya Pandey on 22/04/24.
////
//
import SwiftUI

struct Homepage: View {
    @State private var currentTime = Date()
    @State private var selectedConcernIndex = 0
    @State private var isVitalsExpanded = false
    
    let commonConcerns = ["Concern 1", "Concern 2", "Concern 3", "Concern 4", "Concern 5"]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                    HStack {
                        Image("mednex_logo")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(greeting())
                            .font(.headline)
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                isVitalsExpanded.toggle()
                            }
                        }) {
                            Image(systemName: "waveform.path.ecg")
                                .font(.system(size: 20))
                                .foregroundColor(isVitalsExpanded ? .red : .blue)
                        }
                        .padding(.trailing)
                    }
                    .padding(.horizontal)
                    
                    if isVitalsExpanded {
                        VStack {
                            Vital()
                                .padding()
                            
                            // Add your vital details here
                            
                            Spacer()
                        }
                        .transition(.move(edge: .top))
                        .animation(.easeInOut)
                    } else {
                        VStack(alignment: .leading) {
                            Text("Your Appointments")
                                .font(.title)
                                .padding(.top)
                                .padding(.horizontal)
                            
                            VStack {
                                AppointmentView(doctorName: "Dr. John Doe", time: "10:00 AM - 10:30 AM", venue: "Hospital A")
                                // Add more appointments here if needed
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding()
                            .frame(maxWidth: .infinity) // Ensure maximum width
                            
                            HStack {
                                Text("Today's Medicines")
                                    .font(.title)
                                    .padding(.horizontal)
                                    .padding(.bottom, 0.5)
                                
                                NavigationLink(destination: TodayMeds()) {
                                    Image(systemName: "chevron.right")
                                        .padding(.leading, 80)
                                    
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(1..<4) { index in
                                        MedicationView(symbolName: "pills", name: "Medication \(index)")
                                            .cornerRadius(10)
                                    }
                                }
                                .padding()
                                .background(Color.clear)
                                .cornerRadius(10)
                                .padding()
                            }
                            
                            Text("Common Concerns")
                                .font(.title)
                                .padding(.horizontal)
                                .padding(.bottom, 0.5)
                            
                            GeometryReader { geometry in
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(0..<commonConcerns.count) { index in
                                            Circle()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(index == selectedConcernIndex ? .blue : .gray)
                                                .onTapGesture {
                                                    withAnimation {
                                                        selectedConcernIndex = index
                                                    }
                                                }
                                        }
                                    }
                                    .padding()
                                }
                                .frame(width: geometry.size.width, height: 50) // Adjust height as needed
                            }
                            
                            Spacer()
                        }
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut)
                    }
                }
                .navigationTitle("Home")
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(hex: "e8f2fd"), Color(hex: "ffffff")]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }
    
    
    
    
    private func greeting() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentTime)
        if hour < 12 {
            return "Good Morning"
        } else if hour < 17 {
            return "Good Afternoon"
        } else {
            return "Good Evening"
        }
    }
}

struct AppointmentView: View {
    var doctorName: String
    var time: String
    var venue: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack{
                    Image(systemName: "cross.case")
                    .foregroundColor(.gray); Text(doctorName)}
                HStack{
                    Image(systemName: "clock").foregroundColor(.gray);
                    Text(time)}
                Text(venue)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct MedicationView: View {
    var symbolName: String
    var name: String
    
    var body: some View {
        VStack {
            Image(systemName: symbolName)
                .foregroundColor(.blue)
            Text(name)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        Homepage()
    }
}







//import SwiftUI
//import HealthKit
//
//struct Homepage: View {
//    @State private var currentTime = Date()
//    @State private var selectedConcernIndex = 0
//    @State private var isVitalsExpanded = false
//    
//    @State private var heartRate: Double?
//    @State private var bloodOxygen: Double?
//    @State private var steps: Double?
//    @State private var sleepHours: Double?
//    
//    let healthStore = HKHealthStore()
//    let commonConcerns = ["Concern 1", "Concern 2", "Concern 3", "Concern 4", "Concern 5"]
//    
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .leading) {
//                HStack {
//                    Image("mednex_logo")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                    Text(greeting())
//                        .font(.headline)
//                    Spacer()
//                    
//                    Button(action: {
//                        withAnimation {
//                            isVitalsExpanded.toggle()
//                        }
//                        fetchHealthData()
//                    }) {
//                        Image(systemName: "waveform.path.ecg")
//                            .font(.system(size: 20))
//                    }
//                    .padding(.trailing)
//                }
//                .padding(.horizontal)
//                
//                if isVitalsExpanded {
//                    VStack {
//                        Text("Vitals")
//                            .font(.title)
//                            .padding()
//                        
//                        // Display fetched health data
//                        HealthDataView(title: "Heart Rate", value: heartRate ?? 0, unit: "bpm")
//                        HealthDataView(title: "Blood Oxygen", value: bloodOxygen ?? 0, unit: "%")
//                        HealthDataView(title: "Steps", value: steps ?? 0, unit: "")
//                        HealthDataView(title: "Sleep Hours", value: sleepHours ?? 0, unit: "hours")
//                        
//                        Spacer()
//                    }
//                    .transition(.move(edge: .top))
//                    .animation(.easeInOut)
//                } else {
//                    // Existing code for other sections
//                }
//            }
//            .navigationTitle("Home")
//            .background(
//                LinearGradient(gradient: Gradient(colors: [Color("e8f2fd"), Color("ffffff")]), startPoint: .top, endPoint: .bottom)
//                    .edgesIgnoringSafeArea(.all)
//            )
//        }
//        .onAppear {
//            requestAuthorization()
//        }
//    }
//    
//    private func greeting() -> String {
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: currentTime)
//        if hour < 12 {
//            return "Good Morning"
//        } else if hour < 17 {
//            return "Good Afternoon"
//        } else {
//            return "Good Evening"
//        }
//    }
//    
//    private func requestAuthorization() {
//        let typesToRead: Set<HKObjectType> = [
//            HKObjectType.quantityType(forIdentifier: .heartRate)!,
//            HKObjectType.quantityType(forIdentifier: .bloodOxygen)!,
//            HKObjectType.quantityType(forIdentifier: .stepCount)!,
//            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
//        ]
//        
//        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
//            if !success {
//                print("Error requesting HealthKit authorization: \(error?.localizedDescription ?? "Unknown error")")
//            }
//        }
//    }
//    
//    private func fetchHealthData() {
//        fetchHeartRate()
//        fetchBloodOxygen()
//        fetchSteps()
//        fetchSleepHours()
//    }
//    
//    private func fetchHeartRate() {
//        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
//        let query = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: nil, options: .discreteAverage) { (_, result, error) in
//            guard let result = result, let average = result.averageQuantity() else {
//                print("Error fetching heart rate: \(error?.localizedDescription ?? "")")
//                return
//            }
//            DispatchQueue.main.async {
//                self.heartRate = average.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
//            }
//        }
//        healthStore.execute(query)
//    }
//    
//    private func fetchBloodOxygen() {
//        let bloodOxygenType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!
//        let query = HKStatisticsQuery(quantityType: bloodOxygenType, quantitySamplePredicate: nil, options: .discreteAverage) { (_, result, error) in
//            guard let result = result, let average = result.averageQuantity() else {
//                print("Error fetching blood oxygen: \(error?.localizedDescription ?? "")")
//                return
//            }
//            DispatchQueue.main.async {
//                self.bloodOxygen = average.doubleValue(for: HKUnit.percent())
//            }
//        }
//        healthStore.execute(query)
//    }
//    
//    private func fetchSteps() {
//        let stepsType = HKObjectType.quantityType(forIdentifier: .stepCount)!
//        let query = HKStatisticsQuery(quantityType: stepsType, quantitySamplePredicate: nil, options: .cumulativeSum) { (_, result, error) in
//            guard let result = result, let sum = result.sumQuantity() else {
//                print("Error fetching steps count: \(error?.localizedDescription ?? "")")
//                return
//            }
//            DispatchQueue.main.async {
//                self.steps = sum.doubleValue(for: HKUnit.count())
//            }
//        }
//        healthStore.execute(query)
//    }
//    
//    private func fetchSleepHours() {
//        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
//        let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (_, samples, error) in
//            guard let samples = samples as? [HKCategorySample] else {
//                print("Error fetching sleep data: \(error?.localizedDescription ?? "")")
//                return
//            }
//            let totalSleepHours = samples.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
//            DispatchQueue.main.async {
//                self.sleepHours = totalSleepHours / 3600 // Convert seconds to hours
//            }
//        }
//        healthStore.execute(query)
//    }
//}
//
//struct Homepage_Previews: PreviewProvider {
//    static var previews: some View {
//        Homepage()
//    }
//}






import SwiftUI
import HealthKit

struct Vital: View {
    @State private var currentTime = Date()
    @State private var isVitalsExpanded = true
    
    @State private var heartRate: Double?
    @State private var bloodOxygen: Double?
    @State private var steps: Double?
    @State private var sleepHours: Double?
    
    let healthStore = HKHealthStore()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
         //       headerView
                
//                if isVitalsExpanded {
                 vitalsView
//                        .transition(.slide)
//                } else {
//                    // Content to display when vitals are not expanded
//                    emptyView
//                }
                
                Spacer()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(hex: "e8f2fd"), Color(hex: "ffffff")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
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
            Text("Vitals")
                .font(.title)
                .fontWeight(.bold)
            
            HealthDataView(title: "Heart Rate", value: heartRate ?? 0, unit: "bpm")
            HealthDataView(title: "Blood Oxygen", value: bloodOxygen ?? 0, unit: "%")
            HealthDataView(title: "Steps", value: steps ?? 0, unit: "")
            HealthDataView(title: "Sleep Hours", value: sleepHours ?? 0, unit: "hours")
            
            Spacer()
        }
    }
    
    private var emptyView: some View {
        VStack {
            Text("Expand to view vitals")
                .font(.headline)
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
    
//    private func greeting() -> String {
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: currentTime)
//        if hour < 12 {
//            return "Good Morning"
//        } else if hour < 17 {
//            return "Good Afternoon"
//        } else {
//            return "Good Evening"
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



//struct Homepage_Previews: PreviewProvider {
//    static var previews: some View {
//        Vital()
//    }
//}
