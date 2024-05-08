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
    @ObservedObject var topratedDoctorviewModel = TopRatedDoctorsViewModel()
    @ObservedObject var viewModel = DepartmentViewModel()
    @ObservedObject var departmentViewModel = DepartmentViewModel()
    @ObservedObject var doctorViewModel = DoctorViewModel.shared
//    @State private var selectedSkillType: DepartmentDetail?
  //  let userId = Auth.auth().currentUser?.uid
    
    var body: some View {
        NavigationStack {
            
                VStack(alignment : .leading){
//                    VStack {
//                        NavigationLink(destination: SearchView()){
//                            HStack{
//                                Image(systemName: "magnifyingglass")
//                                    .foregroundStyle(Color.myGray)
//                                Text("Skills, tutors, centers...")
//                                
//                                Spacer()
//                            }
//                            .foregroundStyle(Color.gray)
//                            .padding(3)
//                            .padding(.leading, 10)
//                            .frame(width: 370, height: 35)
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(8)
//                            
//                        }
//                        .onAppear() {
//                            viewModel.fetchDepartmentTypes()
//                        }
//                        .padding()
//                    SearchView()
  //                  }
                    VStack {
                        // Search field for text input
                        VStack{
                            HStack{
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(Color.myGray)
                                    .padding(.leading)
                                
                                TextField("Search by Doctor Name", text: $searchText)
                                    .padding(10)
                                    .cornerRadius(8)
                                    .frame(maxWidth: .infinity)
                                
                            }
                            .padding(3)
                            .background(Color(.tertiarySystemFill))
                            .cornerRadius(8)
                        }
                        .padding(.leading)
                        .padding(.top)
                        .padding(.trailing)


                        if !searchText.isEmpty { // Show only when there's text in search
                            ScrollView {
                                ForEach(departmentViewModel.departmentTypes) { department in
                                    VStack(alignment: .leading) {
                                        // Get filtered doctors by department and searchText
                                        let filteredDoctors = doctorViewModel.doctorDetails.filter { doctor in
                                            (searchText.isEmpty || doctor.fullName.localizedCaseInsensitiveContains(searchText)) &&
                                            department.specialityDetails.contains { $0.doctorId == doctor.id }
                                        }

                                        if !filteredDoctors.isEmpty {
                                            Text("Department: \(department.departmentType)")
                                                .foregroundStyle(Color.myGray)
                                                .font(.headline)
                                                .padding(.leading)
                                                .padding(.top)

                                            ForEach(filteredDoctors, id: \.id) { doctor in
                                                NavigationLink(
                                                    destination: DoctorProfile(
                                                        imageUrl: doctor.profilephoto ?? "default_url", // Provide a valid default
                                                        fullName: doctor.fullName,
                                                        specialist: doctor.speciality,
                                                        doctor: doctor
                                                    )
                                                ) {
                                                    HStack {
                                                        topDoctorCard(fullName: doctor.fullName, specialist: doctor.speciality, doctorUid: doctor.id , imageUrl: doctor.profilephoto ?? "userphoto", doctorDetail: doctor)
                                                    }
                                                    Divider()
                                                }
                                            }
                                        }
                                    }
                                    .onAppear {
                                        if department.specialityDetails.isEmpty {
                                            departmentViewModel.fetchSpecialityOwnerDetails(for: department.id)
                                        }
                                    }
                                }
                            }
                            .frame(minWidth: 300, minHeight: 180)
                        }
                    }
                    .navigationTitle("Search Doctors")

                    Text("Select Departments")
                        .foregroundStyle(Color.myGray)
                        .padding(.leading)
                        .padding(.top)
                   
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
//                            .padding(.horizontal)
                        }
                    } 
                    .foregroundColor(.gray)//End of the scrollView
                   
                    Text("Top Doctors")
                        .foregroundStyle(Color.myGray)
                        .padding()
                    
                    ScrollView {
                 
                    VStack(alignment : .leading){
                        
                        VStack {
                            ForEach(topratedDoctorviewModel.topRatedDoctors) { doctor in
                                VStack(alignment: .leading) {
                                    topDoctorCard(fullName: doctor.fullName, specialist: doctor.speciality, doctorUid: doctor.id , imageUrl: doctor.profilephoto ?? "userphoto", doctorDetail: doctor)
                                }
                            }
                        }
                        .onAppear {
                            topratedDoctorviewModel.fetchTopFiveRatedDoctors()
                        }
                        
                    } //End of VStack
                    
                }  //End of the scroll view
           
            }
                .navigationTitle("Book Appointments")
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
                            .padding(.top)
                        
                        Text("\(specialist)")
                            .font(AppFont.smallReg)
                            
                        
                        HStack{
                            let reviewsForSkillOwner = reviewViewModel.reviewDetails.filter { $0.doctorId == "\(doctorDetail.id)" }
                            if !reviewsForSkillOwner.isEmpty {
                                //Calculating Average of the doctor
                                let averageRating = reviewsForSkillOwner.reduce(0.0) { $0 + Double($1.ratingStar) } / Double(reviewsForSkillOwner.count)
                        
                                Text("\(averageRating, specifier: "%.1f") ⭐️")
                                    .font(AppFont.smallReg)
                        
                                Text("\(reviewsForSkillOwner.count) Review\(reviewsForSkillOwner.count == 1 ? "" : "s")")
                                    .font(AppFont.smallReg)
                            } else {
                                Text("no reviews")
                                    .font(AppFont.smallReg)
                                    .foregroundColor(.black).opacity(0.3)
                
                            }
                            Spacer()
                        }
                        .padding(.bottom)
                        .font(AppFont.smallReg)
                        .onAppear(){
                            reviewViewModel.fetchReviewDetailByDoctorId(doctorId: doctorDetail.id)
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
        .onAppear() {
            reviewViewModel.fetchReviewDetail()
            }
        
    }
}
