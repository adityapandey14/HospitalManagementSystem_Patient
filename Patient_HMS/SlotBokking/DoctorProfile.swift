//
//  DoctorProfile.swift
//  Patient_HMS
//
//  Created by Aditya Pandey on 29/04/24.
//

import SwiftUI

struct DoctorProfile: View {
    var imageUrl : String
    var fullName : String
    var specialist : String
    let doctor: DoctorModel

    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack {
                    VStack(alignment : .leading) {
                        
                        HStack {
                            if let imageUrl = URL(string: imageUrl) {
                                AsyncImage(url: imageUrl) { image in
                                    image
                                        .resizable()
                                        .clipped()
                                        .frame(width: 85, height: 85)
                                        .cornerRadius(50)
                                        .padding(.trailing, 5)
                                } placeholder: {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .clipped()
                                        .frame(width: 85, height: 85)
                                        .cornerRadius(50)
                                        .padding(.trailing, 5)
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 90, height: 90)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .clipped()
                                    .frame(width: 85, height: 85)
                                    .cornerRadius(50)
                                    .padding(.trailing, 5)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("\(fullName)")
                                    .font(AppFont.mediumSemiBold)
                                Text("\(specialist)")
                                    .font(AppFont.smallReg)
                                    .foregroundStyle(Color.black).opacity(0.6)
                                    .padding(.bottom, 0.5)
                            }
                            
                        } // End of HStack
                        .padding()
                        
                        HStack {
                            VStack {
                                Image(systemName: "person.2.fill")
                                    .resizable()
                                    .clipped()
                                    .frame(width: 35, height: 35)
                                    .cornerRadius(50)
                                    .padding(.trailing, 5)
                                    .foregroundColor(.gray)
                                Text("+ 100")
                                Text("Patients")
                            }
                            
                            Spacer()
                            VStack {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .clipped()
                                    .frame(width: 35, height: 35)
                                    .cornerRadius(50)
                                    .padding(.trailing, 5)
                                    .foregroundColor(.gray)
                                Text("4.5")
                                Text("Rating")
                            }
                            
                            Spacer()
                            VStack {
                                Image(systemName: "arrow.up.right.bottomleft.rectangle.fill")
                                    .resizable()
                                    .clipped()
                                    .frame(width: 35, height: 35)
                                    .cornerRadius(50)
                                    .padding(.trailing, 5)
                                    .foregroundColor(.myGray)
                                Text("16 years")
                                Text("Experience")
                            }
                            
                            
                        }
                        .padding()
                        
                        
                        Text("Select Schedule")
                            .padding()
                        
                        HStack{
                           
                            //Calendar Code will be here
                            
                        } //End of HStack
                        Divider()
                            .padding()
                        SlotBookView( doctor: doctor)
                   
                        
                        
                    }  //End of VStack
                    
                } // End of Scroll View
                .navigationTitle("Book Appointment")
            } //End of VStack
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(hex: "e8f2fd"), Color(hex: "ffffff")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
            )
         
            
        } //End of the navigation Stack
    }
}

struct DoctorProfileView_Previews: PreviewProvider {
    static var previews: some View {
        
        let dummyDoctor = DoctorModel(
            id: "1",
            fullName: "Dr. Jane Doe",
            descript: "Expert in cardiology",
            gender: "Female",
            mobileno: "1234567890",
            experience: "10 years",
            qualification: "MD, Cardiology",
            dob: Date(timeIntervalSince1970: 0),  // January 1, 1970
            address: "123 Main St, Springfield",
            pincode: "123456",
            department: "Cardiology",
            speciality: "Cardiologist",
            cabinNo: "101",
            profilephoto: nil  // Can use an actual URL if desired
        )
        DoctorProfile(imageUrl: "www.google.com" , fullName: "Aditya" , specialist: "specialist", doctor: dummyDoctor)
    }
}
