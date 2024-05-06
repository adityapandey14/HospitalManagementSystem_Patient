//
//  Patient_HMSApp.swift
//  Patient_HMS
//
//  Created by Aditya Pandey on 19/04/24.
//

import SwiftUI
import Firebase

@main
struct Patient_HMSApp: App {
    @StateObject var viewModel = AuthViewModel()
    @StateObject var patientViewModel = PatientViewModel()
    @StateObject var presviewModel = PrescriptionViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
     init(){ //to make tab bar have green accent on selected bar icon
        // FirebaseApp.configure()
         if #available(iOS 15.0, *) {
             let appearance = UITabBarAppearance()
             appearance.selectionIndicatorTintColor = UIColor.green
             UITabBar.appearance().scrollEdgeAppearance = appearance
         }
     }
     
     var body: some Scene {
         WindowGroup {
        //     onboardingPageSwiftUIView()
             ContentView()
                 .environmentObject(viewModel)
                 .environmentObject(patientViewModel)
                 .environmentObject(presviewModel)
         }
     }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
