//
//  onboarding.swift
//  Patient_HMS
//
//  Created by admin on 23/04/24.
//

import SwiftUI

struct onboarding: View {
    @State private var isActive = false

    var body: some View {
        VStack {
            if isActive {
                NavigationView {
                    loginView()
                }
            } else {
                splashScreen(imageName: "homePageLogo", duration: 5, nextView: {
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            nextView()
                    }
                }
            }
        }
    }
}

#Preview {
    onboarding()
}
