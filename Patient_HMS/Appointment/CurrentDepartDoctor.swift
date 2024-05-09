////
////  CurrentDepartDoctor.swift
////  Patient_HMS
////
////  Created by Aditya Pandey on 02/05/24.
////
//
//import SwiftUI
//
//struct CurrentDepartDoctor: View {
//    
//    @ObservedObject var viewModel = DepartmentViewModel()
//    @State var selecteddeptType: DepartmentDetail
//    @ObservedObject var doctorViewModel = DoctorViewModel.shared
//   
//    
//    var body: some View {
//        
//        
//        VStack {
//            ForEach(selecteddeptType.specialityDetails) { detail in
//                //    Text("\(detail.cabinNo)")
//                VStack {
//                    if let doctor = doctorViewModel.doctorDetails.first(where: { $0.id == detail.doctorId }) {
//                        topDoctorCard(
//                            fullName: doctor.fullName,
//                            specialist: doctor.speciality,
//                            doctorUid: detail.doctorId,
//                            imageUrl: doctor.profilephoto ?? "www.google.com",
//                            doctorDetail: doctor
//                            
//                        )
//                    } else {
//                        Text("Doctor not found")
//                            .foregroundColor(.gray)
//                    }
//                }
//                .onAppear {
//                    Task {
//                        await doctorViewModel.fetchDoctorDetails() // Fetch the data
//                    }
//                }
//                
//            } // End of the for loop
//        }
//        .onAppear {
//            viewModel.fetchSpecialityOwnerDetails(for: selecteddeptType.id)
//            
//        }
//        
//    }
//}
//
////#Preview {
////    CurrentDepartDoctor()
////}
//
//
//
//
//
//
////if let skillType = skillViewModel.skillTypes.first(where: { $0.id == skillUid }) {
////    VStack {
////        if let detail = skillType.skillOwnerDetails.first(where: { $0.id == skillOwnerDetailsUid }) {
//            



//
//  CurrentDepartDoctor.swift
//  Patient_HMS
//
//  Created by Aditya Pandey on 02/05/24.
//

import SwiftUI

struct CurrentDepartDoctor: View {
    
    @ObservedObject var viewModel = DepartmentViewModel()
    @State var selecteddeptType: DepartmentDetail
    @ObservedObject var doctorViewModel = DoctorViewModel.shared
   
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(selecteddeptType.specialityDetails) { detail in
                    VStack(spacing: 20) {
                        if let doctor = doctorViewModel.doctorDetails.first(where: { $0.id == detail.doctorId }) {
                            topDoctorCard(
                                fullName: doctor.fullName,
                                specialist: doctor.speciality,
                                doctorUid: detail.doctorId,
                                imageUrl: doctor.profilephoto ?? "www.google.com",
                                doctorDetail: doctor
                            )
                        } else {
                            Text("Doctor not found")
                                .foregroundColor(.gray)
                        }
                    }
                    .onAppear {
                        Task {
                            await doctorViewModel.fetchDoctorDetails() // Fetch the data
                        }
                    }
                } // End of the for loop
            }
            .navigationTitle(selecteddeptType.departmentType.capitalized)
            .onAppear {
                viewModel.fetchSpecialityOwnerDetails(for: selecteddeptType.id)
            }
        }
    }
}
