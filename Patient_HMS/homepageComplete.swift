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
            Homepage()
                .tabItem {
                    Label("Home", systemImage: "house")
                        .padding(.top)
                }
            
            DoctorProfile(imageUrl: "www.google.com", fullName: "fullName", specialist: "specialist", doctor: dummyDoctor)
                .tabItem {
                    Label("Appointment", systemImage: "person.crop.rectangle.fill")
                        .padding(.top)
                }
        
            HealthRecordAdd()
                .tabItem {
                    Label("HealthRecord", systemImage: "folder.fill")
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


