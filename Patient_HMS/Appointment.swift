//
//  Appointment.swift
//  Patient_HMS
//
//  Created by Aditya Pandey on 29/04/24.
//

import SwiftUI

struct Appointment: View {
    @State private var searchText = ""
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
                        
   //                     ForEach(0..<3) { row in
                      
                            Text("Cardiology")
                                .frame(width : 140 , height: 50)
                                .background(Color.white)
                                .cornerRadius(10)
                            
                            Text("General")
                                .frame(width : 140 , height: 50)
                                .background(Color.white)
                                .cornerRadius(10)
                            
                            Text("Pediatric")
                                .frame(width : 140 , height: 50)
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                    .padding(.horizontal)
                            
                      
                    } //End of the scrollView
                   
                 
                    
                 
                    Spacer()
                    ScrollView {
                 
                    
                    
                    
                    VStack(alignment : .leading){
                        Text("Top Doctors")
                            .foregroundStyle(Color.myGray)
                            .padding()
                        
                        
                        topDoctorCard(fullName: "First", specialist: "Pediatrics", doctorUid: "1", imageUrl: "www.google.com")
                        
                        topDoctorCard(fullName: "Second", specialist: "Pediatrics", doctorUid: "2", imageUrl: "www.google.com")
                        topDoctorCard(fullName: "Third", specialist: "Pediatrics", doctorUid: "3", imageUrl: "www.google.com")
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
    @ObservedObject var reviewViewModel = ReviewViewModel()
    
    @State private var isCopied = false

    var body: some View {
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
                    Text("\(specialist)")
                        .font(AppFont.smallReg)
                        .foregroundStyle(Color.black).opacity(0.6)
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
        }
        .frame(maxWidth: .infinity, maxHeight: 110)
        .foregroundColor(Color.black)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal,20)
        
    }
}
