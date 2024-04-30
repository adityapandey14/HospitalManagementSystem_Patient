//
//  ProfilePage.swift
//  Patient_HMS
//
//  Created by Arnav on 23/04/24.
//

//import SwiftUI

//struct ProfilePage: View {
//    @EnvironmentObject var profileViewModel:PatientViewModel
//    @EnvironmentObject var viewModel:AuthViewModel
//    @State private var isEditSuccessful = false
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack{
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            viewModel.signOut()
//                        }) {
//                            Image(systemName: "gear")
//                                .resizable()
//                                .frame(width: 30, height: 30)
//                                .foregroundColor(Color.blue)
//                        }
//                        .padding(.all, 10)
//                    }
//
//                    HStack{
//                        if let posterURL = profileViewModel.currentProfile.profilephoto {
//                            AsyncImage(url: URL(string: posterURL)) { phase in
//                                switch phase {
//                                case .success(let image):
//                                    image
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 350, height: 200)
//                                        .cornerRadius(20.0)
//                                        .clipShape(Circle())
//                                        .padding([.leading, .bottom, .trailing])
//                                default:
//                                    ProgressView()
//                                        .frame(width: 50, height: 50)
//                                        .padding([.leading, .bottom, .trailing])
//                                }
//                            }
//                        } else {
//                            Image(uiImage: UIImage(named: "default_hackathon_poster")!)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 350, height: 200)
//                                .cornerRadius(20.0)
//                                .clipShape(Circle())
//                                .padding([.leading, .bottom, .trailing])
//                        }
//                    }
//                    .padding(.bottom, 90.0)
//                    
//                }.padding(.top, 35)
//                   
//                
//                Text(profileViewModel.currentProfile.fullName)
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundColor(Color.black)
//                Text(profileViewModel.currentProfile.bloodgroup)
//                    .font(.subheadline)
//                    .padding(.bottom)
//                Text(profileViewModel.currentProfile.emergencycontact)
//                    .font(.subheadline)
//                    .padding(.bottom)
//                Button(action: edit) {
//                    Text("Edit Profile")
//                        .font(AppFont.mediumSemiBold)
//                        .foregroundColor(.black)
//                }
//                .frame(width: 250, height: 35)
//                .padding()
//                .background(Color.accent)
//                .cornerRadius(50)
//                .sheet(isPresented: $isEditSuccessful) {
//                    Profile_Edit()
//                }
//                
//                
////                .navigationTitle("Profile")
//            }
//            .ignoresSafeArea()
//            .navigationBarTitleDisplayMode(.inline)
//            .onAppear{
//                print(viewModel.currentUser?.id ?? <#default value#>)
//                profileViewModel.fetchProfile(userId: viewModel.currentUser?.id)}
//            
////            .toolbar {
////                ToolbarItem(placement: .navigationBarTrailing) {
////                    HStack
////                    {
////                        Button(action: {}){
////                            NavigationLink(destination: Settings()){
////                                Image(systemName: "gear")
////
////                            }
////                        }
////                    }
////                }
////            }
//           
//        }
//       
//    }
//    private func edit() {
//        isEditSuccessful = true
//    }
//}
//
//struct CustomShape: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        
//        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
//        
//        let radius = rect.width / 4
//        let center = CGPoint(x: rect.midX, y: rect.maxY)
//        path.addArc(center: center, radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 180), clockwise: true)
//        
//        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
//        
//        return path
//    }
//}


//struct Profile_Previews: PreviewProvider {
//    static var previews: some View {
//        Profile()
//            .environmentObject(ProfileViewModel())
//            .environmentObject(UserViewModel())
//    }
//}

import SwiftUI

struct ProfileView: View {
        @EnvironmentObject var profileViewModel:PatientViewModel
        @EnvironmentObject var viewModel:AuthViewModel
        @State private var isEditSuccessful = false
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "e8f2fd"), Color(hex: "ffffff")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Profile")
                        .font(.system(size: 29))
                        .padding(.trailing, 250)
                        .padding(.top, 100)
                        .bold()
                    
                    // Profile content
                    HStack {
                        // Profile image
                        HStack{
                                                if let posterURL = profileViewModel.currentProfile.profilephoto {
                                                    AsyncImage(url: URL(string: posterURL)) { phase in
                                                        switch phase {
                                                        case .success(let image):
                                                            image
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fill)
                                                                .frame(width: 100, height: 100)
                                                                .cornerRadius(10.0)
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
                                                        .frame(width: 100, height: 100)
                                                        .cornerRadius(10.0)
                                                        .clipShape(Circle())
                                                        .padding([.leading, .bottom, .trailing])
                                                }
                                            }
                                            
                        
                        // Profile details
                        VStack(alignment: .leading) {
                            Text(profileViewModel.currentProfile.fullName)
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                                .bold()
                            Text(viewModel.currentUser?.email ?? "email")
                                .font(.system(size: 13))
                                .foregroundColor(.white)
                                .padding(.bottom, 1)
                                .italic()
                            Text(profileViewModel.currentProfile.mobileno)
                                .font(.system(size: 13))
                                .foregroundColor(.black)
                        }
                        .padding(.trailing, 38)
                        
                        Button(action: edit){
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                            .padding(.leading)}
                            .sheet(isPresented: $isEditSuccessful) {
                                             Profile_Edit()
                                           }
                          
                    }
                    .padding(.top, 15)
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 310, height: 150)
                            .cornerRadius(10)
                            .padding(.top, 70)
                        
                        VStack {
                            
                            Button {
                                
                            } label : {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .frame(width: 20, height: 20)
//                                    .padding(.trailing, 250)
                                Text("My Appointments")
                                    .padding(.leading, 20)
                                    .bold()
//                                    .offset(x: 30)
                                Image(systemName: "chevron.right")
                                    .padding(.leading, 50)
//                                    .padding(.trailing, 5)
                            }
                            .padding(.top, 60)
                            .offset(y: -5)
                            Button {
                                
                            } label :{
                                Image(systemName: "doc.fill")
                                    .resizable()
                                    .frame(width: 18, height: 20)
                                    .offset(x: -30)
                                Text("My Health Records")
                                    .bold()
                                    .offset(x: -8)
                                Image(systemName: "chevron.right")
                                    .offset(x: 32)
                            }
                            .offset(y: 2)
                            
                            
                            
                            Button {
                                
                            } label : {
                                Image(systemName: "book.pages.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .offset(x: -53)
                                Text("Prescriptions")
                                    .offset(x: -31)
                                    .bold()
                                Image(systemName: "chevron.right")
                                    .offset(x: 52)
                            }
                            .offset(y: 10)
                        }
                    }
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 310, height: 100)
                            .cornerRadius(10)
                            .padding(.top, 70)
                        
                        VStack {
                            
                            Button {
                                
                            } label :{
                                Image(systemName: "key")
                                    .resizable()
                                    .frame(width: 13, height: 20)
//                                    .padding(.trailing, 250)
                                
                                Text("Change Password")
                                    .padding(.leading, 20)
                                    .bold()
//                                    .offset(x: 30)
                                Image(systemName: "chevron.right")
                                    .padding(.leading, 50)
//                                    .padding(.trailing, 5)
                            }
                            .padding(.top, 60)
                            .offset(y: -5)
                            
                            
                            Button {
                                    viewModel.signOut()
                            } label : {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
//                                    .resizable()
//                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.red)
                                    .offset(x: -85)
                                    .offset(y: 4)
                                Text("Logout")
                                    .foregroundColor(Color.red)
                                    .bold()
                                    .offset(x: -73)
                                    .offset(y: 4)
                          
                            }
                            .offset(y: 3)
                        } //End of Vstack
                    }
                    .padding(.bottom, 300)
                    .offset(y: -30)
                }
                .padding(.top, 110)
            }
        }
                    .onAppear{
                        print(viewModel.currentUser?.id ?? "")
                        profileViewModel.fetchProfile(userId: viewModel.currentUser?.id)}
    }
    private func edit() {
          isEditSuccessful = true
      }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


// Extension to create Color from hexadecimal value
//extension Color {
//    init(hex: UInt, alpha: Double = 1) {
//        self.init(
//            .sRGB,
//            red: Double((hex >> 16) & 0xFF) / 255,
//            green: Double((hex >> 8) & 0xFF) / 255,
//            blue: Double(hex & 0xFF) / 255,
//            opacity: alpha
//        )
//    }
//}


