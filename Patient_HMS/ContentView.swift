//
//  ContentView.swift
//  Patient_HMS
//
//  Created by Aditya Pandey on 19/04/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @EnvironmentObject var profileViewModel : PatientViewModel
    var body: some View {
        //Imageview() use this for image upload and retrival
        Group {
            if $viewModel.userSession.wrappedValue != nil{
                MTabView()
            } else {
                onboardingPage()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
}

