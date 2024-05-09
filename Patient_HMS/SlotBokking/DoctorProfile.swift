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
    @ObservedObject var reviewViewModel = ReviewViewModel()
    @State private var isFetching = false

    
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
                                    .foregroundStyle(Color(uiColor: .secondaryLabel)).opacity(0.6)
                                    .padding(.bottom, 0.5)
                            }
                            
                        } // End of HStack
                        .padding()
                        
                        HStack {
                            
   //Fetching review of current user
                            let reviewsForSkillOwner = reviewViewModel.reviewDetails.filter { $0.doctorId == doctor.id }

                            var reviewCount = reviewViewModel.reviewDetails.filter { $0.doctorId == doctor.id }.count
                    
                            VStack {
                                Image(systemName: "person.2.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                                    .foregroundColor(.accentBlue)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .clipShape(Circle())
                                VStack() {
                                    Text("\(reviewCount)")
                                        .font(.system(size: 17))
                                    Text("Patients")
                                        .font(.system(size: 15))
                                        .fontWeight(.light)
                                }
                            }
                            
                            Spacer()
                            VStack {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 23)
                                    .foregroundColor(.accentBlue)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .clipShape(Circle())

                                if !reviewsForSkillOwner.isEmpty {
                                    //Calculating Average of the doctor
                                    let averageRating = reviewsForSkillOwner.reduce(0.0) { $0 + Double($1.ratingStar) } / Double(reviewsForSkillOwner.count)
                            
                                    VStack{
                                        Text("\(averageRating, specifier: "%.1f") ⭐️")
                                            .font(.system(size: 17))
                                
                                        Text("\(reviewsForSkillOwner.count) Review\(reviewsForSkillOwner.count == 1 ? "" : "s")")
                                            .font(.system(size: 15))
                                            .fontWeight(.light)
                                    }
                                } else {
                                    VStack{
                                        Text("no")
                                        Text("reviews")
                                            .font(.system(size: 15))
                                            .fontWeight(.light)
                                    }
                    
                                } //else
                           
                            }//VStack
                            
                            Spacer()
                            VStack {
                                Image(systemName: "arrow.up.right.bottomleft.rectangle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                                    .foregroundColor(.accentBlue)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .clipShape(Circle())
                                VStack{
                                    Text(doctor.experience)
                                        .font(.system(size: 17))
                                    Text("Experience")
                                        .font(.system(size: 15))
                                        .fontWeight(.light)
                                }
                            }
                            
                            
                        }
                        .padding(.horizontal)
                        .padding()
                        .onAppear() {
                            reviewViewModel.fetchReviewDetail()
                            }
                        
                        
//                        Text("Select Schedule")
//                            .padding()
    
                        SlotBookView( doctor: doctor)
                            .padding(.top)
                   
                        
                        
                    }  //End of VStack
                    
                } // End of Scroll View
                .navigationTitle("Book Appointment")
            } //End of VStack
            .background(Color.clear)
         
            
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
