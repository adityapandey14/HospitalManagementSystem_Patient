//
//  Homepage.swift
//  Patient_HMS
//
//  Created by Aditya Pandey on 22/04/24.
//

import SwiftUI

struct Homepage: View {
    @State private var currentTime = Date()
    @State private var selectedConcernIndex = 0
    @State private var isVitalsExpanded = false
    
    let commonConcerns = ["Concern 1", "Concern 2", "Concern 3", "Concern 4", "Concern 5"]
    
    var body: some View {
        NavigationView {
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
                    }
                    .padding(.trailing)
                }
                .padding(.horizontal)
                
                if isVitalsExpanded {
                    VStack {
                        Text("Vitals")
                            .font(.title)
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
                        
                        Text("Today's Medicines")
                            .font(.title)
                            .padding(.horizontal)
                            .padding(.bottom, 0.5)
                        
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
