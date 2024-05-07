//
//  homepageComplete.swift
//  Patient_HMS
//
//  Created by sarthak Nahar on 29/04/24.
//

import SwiftUI

struct homepageComplete: View {
   
    var body: some View {
        TabView {
            ChiduHomepage()
                .tabItem {
                    Label("Home", systemImage: "house")
                        .padding(.top)
                }
                MedicineView()
                .tabItem {
                    Label("Home", systemImage: "house")
                        .padding(.top)
                }
            AppointmentRatingView()
                .tabItem {
                    Label("Rating", systemImage: "folder.fill")
                        .padding(.top)
                }
            
         
        
            HealthRecordAdd()
                .tabItem {
                    Label("HealthRecord", systemImage: "folder.fill")
                        .padding(.top)
                }
            
            Appointment()
                .tabItem {
                    Label("Appointment", systemImage: "person.fill")
                        .padding(.top)
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                        .padding(.top)
                }
            
        }
    }
}


