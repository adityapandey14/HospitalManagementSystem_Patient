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
        
            HealthRecordAdd()
                .tabItem {
                    Label("HealthRecord", systemImage: "house")
                        .padding(.top)
                }
            
        }
    }
}

#Preview {
    homepageComplete()
}