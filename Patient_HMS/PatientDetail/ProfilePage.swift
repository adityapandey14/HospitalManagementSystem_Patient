//
//  ProfilePage.swift
//  Patient_HMS
//
//  Created by Arnav on 23/04/24.
//

import SwiftUI

struct ProfilePage: View {
    @EnvironmentObject var profileViewModel:PatientViewModel
    @EnvironmentObject var viewModel:AuthViewModel
    @State private var isEditSuccessful = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack{
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.signOut()
                        }) {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.blue)
                        }
                        .padding(.all, 10)
                    }

                    HStack{
                        if let posterURL = profileViewModel.currentProfile.profilephoto {
                            AsyncImage(url: URL(string: posterURL)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 350, height: 200)
                                        .cornerRadius(20.0)
                                        .clipShape(Circle())
                                        .padding([.leading, .bottom, .trailing])
                                default:
                                    ProgressView()
                                        .frame(width: 50, height: 50)
                                        .padding([.leading, .bottom, .trailing])
                                }
                            }
                        } else {
                            Image(uiImage: UIImage(named: "default_hackathon_poster")!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 350, height: 200)
                                .cornerRadius(20.0)
                                .clipShape(Circle())
                                .padding([.leading, .bottom, .trailing])
                        }
                    }
                    .padding(.bottom, 90.0)
                    
                }.padding(.top, 35)
                   
                
                Text(profileViewModel.currentProfile.fullName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                Text(profileViewModel.currentProfile.bloodgroup)
                    .font(.subheadline)
                    .padding(.bottom)
                Text(profileViewModel.currentProfile.emergencycontact)
                    .font(.subheadline)
                    .padding(.bottom)
                Button(action: edit) {
                    Text("Edit Profile")
                        .font(AppFont.mediumSemiBold)
                        .foregroundColor(.black)
                }
                .frame(width: 250, height: 35)
                .padding()
                .background(Color.accent)
                .cornerRadius(50)
                .sheet(isPresented: $isEditSuccessful) {
                    Profile_Edit()
                }
                
                
//                .navigationTitle("Profile")
            }
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                print(viewModel.currentUser?.id)
                profileViewModel.fetchProfile(userId: viewModel.currentUser?.id)}
            
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    HStack
//                    {
//                        Button(action: {}){
//                            NavigationLink(destination: Settings()){
//                                Image(systemName: "gear")
//
//                            }
//                        }
//                    }
//                }
//            }
           
        }
       
    }
    private func edit() {
        isEditSuccessful = true
    }
}

struct CustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        let radius = rect.width / 4
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        path.addArc(center: center, radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 180), clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        return path
    }
}


//struct Profile_Previews: PreviewProvider {
//    static var previews: some View {
//        Profile()
//            .environmentObject(ProfileViewModel())
//            .environmentObject(UserViewModel())
//    }
//}

