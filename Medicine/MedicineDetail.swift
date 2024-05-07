//
//  MedicineDetail.swift
//  Patient_HMS
//
//  Created by admin on 07/05/24.
//

import Foundation
import SwiftUI



struct MedicineDetail: View {
    @State private var selectedDays: Set<String> = []
    @State private var selectedDate = Date()
    @State private var selectedDate1 = Date()
    @State private var isToggled = false
    @State private var isToggled1 = false
    @State private var isToggled2 = false


      let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var body: some View {
        
        NavigationStack {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color(hex: "e8f2fd"), Color(hex: "ffffff")]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                    
                ScrollView {
                    VStack {
                        Text("Zincovit CL")
                            .bold()
                        //                        .padding(.bottom, 570)
                            .font(.system(size: 30))
                            .padding(.bottom, 50)
                        
                        HStack {
                            ZStack {
                                Rectangle()
                                    .fill(Color.white)
                                    .cornerRadius(10)
                                    .frame(width: 80, height: 80)
                                Image(systemName: "pill.fill")
                                    .resizable()
                                    .frame(width:30, height: 30)
                            }
                            VStack {
                                Text("Zincovit CL")
                                    .bold()
                                    .font(.system(size: 19))
                                Text("After meal")
                                    .font(.system(size: 13))
                                    .italic()
                                    .padding(.trailing, 35)
                            }
                        }
                        .padding(.trailing, 130)
                        
                        
                        VStack {
                            Text("Select days for medicine reminder:")
                                .font(.headline)
                                .padding()
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(daysOfWeek, id: \.self) { day in
                                        DayButton(title: day, isSelected: self.selectedDays.contains(day)) {
                                            if self.selectedDays.contains(day) {
                                                self.selectedDays.remove(day)
                                            } else {
                                                self.selectedDays.insert(day)
                                            }
                                        }
                                    }
                                }
                                .padding()
                            }
                            
                            Text("Selected Days: \(Array(selectedDays).joined(separator: ", "))")
                                .padding()
                            
                            Spacer()
                        }
                        
                        DatePicker("Start Date", selection: $selectedDate, displayedComponents: .date)
                            .padding()
                        //                        .padding(.bottom)
                        DatePicker("End Date", selection: $selectedDate1, displayedComponents: .date)
                            .padding()
                        //                        .padding(.bottom, 60)
                        
                        ScrollView {
                            VStack {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.white)
                                        .cornerRadius(10)
                                        .frame(width: 360, height: 50)
                                    HStack {
                                        Text("08:00")
                                            .padding(.leading, 40)
                                        Toggle("", isOn: $isToggled)
                                            .padding(.trailing, 30)
                                    }
                                }
                                ZStack {
                                    Rectangle()
                                        .fill(Color.white)
                                        .cornerRadius(10)
                                        .frame(width: 360, height: 50)
                                    HStack {
                                        Text("12:00")
                                            .padding(.leading, 40)
                                        Toggle("", isOn: $isToggled1)
                                            .padding(.trailing, 30)
                                    }
                                }
                                ZStack {
                                    Rectangle()
                                        .fill(Color.white)
                                        .cornerRadius(10)
                                        .frame(width: 360, height: 50)
                                    HStack {
                                        Text("10:00")
                                            .padding(.leading, 40)
                                        Toggle("", isOn: $isToggled2)
                                            .padding(.trailing, 30)
                                    }
                                }
                                
                            }
                            .padding(.top)
                        }
                    }
                    .padding(.bottom, 200)
                }
            }
        }
    }
}

struct DayButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(isSelected ? .white : .black)
                .padding()
                .background(isSelected ? Color.black : Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

struct MedicineDetail_Previews: PreviewProvider {
    static var previews: some View {
        MedicineDetail()
    }
}
