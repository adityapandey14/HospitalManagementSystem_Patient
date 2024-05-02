//
//  Appointment.swift
//  Patient_HMS
//
//  Created by Aditya Pandey on 29/04/24.
//

import SwiftUI
import FirebaseAuth

struct Appointment: View {
    @State private var searchText = ""
    
    @ObservedObject var viewModel = DepartmentViewModel()
//    @State private var selectedSkillType: DepartmentDetail?
  //  let userId = Auth.auth().currentUser?.uid
    
    var body: some View {
        NavigationStack {
            
                VStack(alignment : .leading){
                    
                    HStack{
                        TextField("Search doctor", text: $searchText)
                            .padding(10)
                            .padding(.leading)
                            .background(Color.elavated)
                            .textFieldStyle(PlainTextFieldStyle())
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity)
                           
                    }
                    .padding()
                  
                        Text("Select Departments")
                        .padding()
                   
                    ScrollView(.horizontal) {
                        
                        HStack{
                            
                            ForEach(viewModel.departmentTypes) { departmentType in
                                VStack(alignment: .leading) {
                                    
                                    let dept = departmentType.departmentType

                                    // Get the first character and capitalize it
                                    let firstCapital = dept.prefix(1).uppercased()

                                    // Get the rest of the string
                                    let restOfString = dept.dropFirst()

                                    // Concatenate the capitalized first character with the rest of the string
                                    let deptWithFirstCapital = firstCapital + restOfString
                                    
                                    NavigationLink(
                                        destination: CurrentDepartDoctor(selecteddeptType : departmentType),
                                           label: {
                                               Text("\(deptWithFirstCapital)")
                                                   .frame(width: 140, height: 50)
                                                   .background(Color.white)
                                                   .cornerRadius(10)
                                                   .font(.headline)
                                                   .padding()
                                           }
                                       )
                                       .onAppear {
                                           // Assuming you want this to happen when the view appears
                                        //   selectedSkillType = departmentType
                                           viewModel.fetchSpecialityOwnerDetails(for: departmentType.id)
                                       }

                                   
                                    
                                    
                                } //end of the vstack
                                
                            } //end of the for loop
                            .padding(.horizontal)
                        }
                            
                      
                    } //End of the scrollView
                   
                    Spacer()
                    Text("Top Doctors")
                        .foregroundStyle(Color.myGray)
                        .padding()
                    
                    ScrollView {
                 
                    VStack(alignment : .leading){
                      
//                        ForEach(viewModel.departmentTypes) { departmentType in
//                            ForEach(departmentType.specialityDetails) { detail in
//                                topDoctorCard(fullName: "First", specialist: "Pediatrics", doctorUid: "1", imageUrl: "www.google.com")
//                            }
//                        }
                            
                        
                        
        //                topDoctorCard(fullName: "First", specialist: "Pediatrics", doctorUid: "1", imageUrl: "www.google.com")
                      
                    }
                    
                }  //End of the scroll view
           
            }
                .navigationTitle("Book Appointment")
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(hex: "e8f2fd"), Color(hex: "ffffff")]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                    
                )
             
            
        } //End of the Navigation Stack
      
 

    
        
    }
}

#Preview {
    Appointment()
}


struct topDoctorCard : View {
    var fullName: String
    var specialist : String
    var doctorUid : String
    var imageUrl : String
    var doctorDetail : DoctorModel
    @ObservedObject var reviewViewModel = ReviewViewModel()
    @ObservedObject var doctorViewModel = DoctorViewModel.shared
    
    @State private var isCopied = false

    var body: some View {
        NavigationLink(destination : DoctorProfile(imageUrl: imageUrl, fullName: fullName, specialist: specialist, doctor: doctorDetail)) {
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        if let imageUrl = URL(string: imageUrl) {
                            AsyncImage(url: imageUrl) { image in
                                image
                                    .resizable()
                                    .frame(width: 85, height: 85) // Square shape with equal width and height
                                    .foregroundColor(.gray) // Optional color
                                    .padding(.trailing, 5)
                            } placeholder: {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 85, height: 85)
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 5)
                                
                            }
                            .frame(width: 90, height: 90)
                        } else {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 85, height: 85)
                                .foregroundColor(.gray)
                                .padding(.trailing, 5)
                            
                        }
                        
                    } //End of VStack
                    
                    VStack(alignment: .leading) {
                        Text("\(fullName)")
                            .font(AppFont.mediumSemiBold)
                            .foregroundStyle(Color.black)
                        Text("\(specialist)")
                            .font(AppFont.smallReg)
                            .foregroundStyle(Color.black)
                            .padding(.bottom, 0.5)
                        
                        
                        //reviews
                        
                        
                        HStack{
                            let reviewsForDoctor = reviewViewModel.reviewDetails.filter { $0.doctorId == doctorUid}
                            
                            if !reviewsForDoctor.isEmpty {
                                let averageRating = reviewsForDoctor.reduce(0.0) { $0 + Double($1.ratingStar) } / Double(reviewsForDoctor.count)
                                
                                Text("⭐️ \(averageRating, specifier: "%.1f ") |")
                                    .font(AppFont.smallReg)
                                    .foregroundColor(.myGray)
                                
                                Text("\(reviewsForDoctor.count) Review\(reviewsForDoctor.count == 1 ? "" : "s")")
                                    .font(AppFont.smallReg)
                                    .foregroundStyle(.myGray)
                            } else {
                                Text("no reviews")
                                    .font(AppFont.smallReg)
                                    .foregroundColor(.myGray)
                                //                                .padding(.bottom)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 4)
                        .font(AppFont.smallReg)
                        .onAppear() {
                            ReviewViewModel().fetchReviewDetail()
                        }
                        
                    }
                    
                    Spacer()
                }
                .padding()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 110)
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal,20)
        }
        
    }
}