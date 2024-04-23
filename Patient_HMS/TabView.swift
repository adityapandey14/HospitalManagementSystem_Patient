//
//  TabView.swift
//  Patient_HMS
//
//  Created by Arnav on 23/04/24.
//

import Foundation
import SwiftUI

struct MTabView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var profileViewModel: PatientViewModel
    var body: some View {
        TabView {
            Homepage()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            HealthRecordAdd()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            ProfilePage()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .navigationBarHidden(true)
    }
}
