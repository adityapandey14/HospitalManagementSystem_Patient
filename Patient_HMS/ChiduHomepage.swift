//
//  ChiduHomepage.swift
//  Patient_HMS
//
//  Created by ChiduAnush on 07/05/24.
//

import SwiftUI

struct ChiduHomepage: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var profileViewModel:PatientViewModel
    var body: some View {
        
        
        ScrollView {
            
            //logo, (goodmorning, name), vitals button.
            HStack(spacing: 10){
                Image(systemName: colorScheme == .dark ? "homePageLogoBlue" : "homePageLogo")
                VStack(alignment: .leading) {
                    Text("Good Morning")
                        .font(.system(size: 19))
                    Text(profileViewModel.currentProfile.fullName )
                        .foregroundStyle(Color("accentBlue"))
                        .font(.system(size: 19))
                }
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "doc.text.below.ecg")
                        .font(.title)
                })
            }
            .padding(.horizontal)
            .padding(.top, 40)
            
            
            //upcoming Appointments
            HStack {
                Text("Upcoming Appointments")
                    .font(.system(size: 17))
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                Spacer()
            }
            .padding(.top, 30)
            .padding(.horizontal)
            .padding(.bottom, 10)
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: -15) {
                    HStack {
                        VStack(alignment: .leading, spacing: 20){
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Dr. Lorem Ipsum")
                                    .font(.system(size: 17))
                                Text("Cardiologist")
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color("accentBlue"))
                            }
                            
                            VStack(spacing: 10){
                                HStack(spacing: 10) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 21))
                                    Text("24th April 2024")
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                                HStack(spacing: 10){
                                    Image(systemName: "clock")
                                        .font(.system(size: 21))
                                    Text("02:30 PM - 03:00 PM")
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(minWidth: 320)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    HStack {
                        VStack(alignment: .leading, spacing: 20){
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Dr. Lorem Ipsum")
                                    .font(.system(size: 17))
                                Text("Cardiologist")
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color("accentBlue"))
                            }
                            
                            VStack(spacing: 10){
                                HStack(spacing: 10) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 21))
                                    Text("24th April 2024")
                                    Spacer()
                                }
                                HStack(spacing: 10){
                                    Image(systemName: "clock")
                                        .font(.system(size: 21))
                                    Text("02:30 PM - 03:00 PM")
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(minWidth: 320)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                }
            }
            
            
            //Today's Medicines
            HStack {
                Text("Today's Medicines")
                    .font(.system(size: 17))
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                Spacer()
            }
            .padding(.top, 35)
            .padding(.horizontal)
            .padding(.bottom, 10)
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: -15) {
                    HStack(spacing: 15) {
                        Image("iconTablet")
                        VStack(alignment: .leading) {
                            Text("Zincovit CL")
                                .font(.system(size: 15))
                            Text("2 Tablespoon, After Meal")
                                .font(.system(size: 13))
                                .foregroundStyle(Color("accentBlue"))
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    HStack(spacing: 15) {
                        Image("iconTablet")
                        VStack(alignment: .leading) {
                            Text("Zincovit CL")
                                .font(.system(size: 15))
                            Text("2 Tablespoon, After Meal")
                                .font(.system(size: 13))
                                .foregroundStyle(Color("accentBlue"))
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                }
            }
            
            
            //Common Concerns
            HStack {
                Text("Common Concerns")
                    .font(.system(size: 17))
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                Spacer()
            }
            .padding(.top, 35)
            .padding(.horizontal)
            .padding(.bottom, 10)
            HStack(spacing: 20) {
                VStack {
                    Circle()
                        .frame(width: 42, height: 42)
                        .foregroundStyle(Color("accentBlue"))
                        .opacity(0.2)
                    Text("Coungh, cold\nFever")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 11))
                        .opacity(0.8)
                }
                VStack {
                    Circle()
                        .frame(width: 42, height: 42)
                        .foregroundStyle(Color("accentBlue"))
                        .opacity(0.2)
                    Text("Child\nnot well")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 11))
                        .opacity(0.8)
                }
                VStack {
                    Circle()
                        .frame(width: 42, height: 42)
                        .foregroundStyle(Color("accentBlue"))
                        .opacity(0.2)
                    Text("Depression\nor Anxiety")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 11))
                        .opacity(0.8)
                }
                VStack {
                    Circle()
                        .frame(width: 42, height: 42)
                        .foregroundStyle(Color("accentBlue"))
                        .opacity(0.2)
                    Text("Acne &\nPimples")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 11))
                        .opacity(0.8)
                }
                VStack {
                    Circle()
                        .frame(width: 42, height: 42)
                        .foregroundStyle(Color("accentBlue"))
                        .opacity(0.2)
                    Text("Period\nProblems")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 11))
                        .opacity(0.8)
                }
            }
        }
        
        
        

    }
}

#Preview {
    ChiduHomepage()
}
