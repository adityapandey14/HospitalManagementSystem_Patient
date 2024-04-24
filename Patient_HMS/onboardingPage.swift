//
//  onboardingPage.swift
//  Patient_HMS
//
//  Created by admin on 23/04/24.
//

import SwiftUI

struct onboardingPage: View {
    @State private var isActive = false

    var body: some View {
        VStack {
            if isActive {
                NavigationView {
                    loginView()
                }
            } else {
                splashScreen(imageName: "homePageLogo", duration: 2.0, nextView: {
                    withAnimation {
                        isActive = true
                    }
                })
            }
        }
    }
}



struct splashScreen: View {
    let imageName: String
    let duration: TimeInterval
    let nextView: () -> Void
    
    var body: some View {
        ZStack{
            Color.solitude.edgesIgnoringSafeArea(.all)
            VStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onAppear {
                        // Animate the image with spring animation
                        withAnimation(.easeIn(duration: 1.0)) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                nextView()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    onboardingPage()
}
