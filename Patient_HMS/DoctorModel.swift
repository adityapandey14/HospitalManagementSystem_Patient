//
//  DoctorModel.swift
//  Patient_HMS
//
//  Created by Arnav on 30/04/24.
//

import Foundation
import SwiftUI


struct DoctorModel: Equatable, Codable{
    var id : String
    var fullName : String
    var descript : String
    var gender: String
    var mobileno: String
    var experience :String
    var qualification:String
    var dob:Date
    var address:String
    var pincode:String
    var department : String
    var speciality : String
    var cabinNo : String
    var profilephoto: String?
    
}


let dummyDoctor = DoctorModel(
    id: "1",
    fullName: "Dr. John Smith",
    descript: "Expert in cardiology",
    gender: "Male",
    mobileno: "1234567890",
    experience: "10 years",
    qualification: "MD",
    dob: Date(timeIntervalSince1970: 0),  // Example date (Jan 1, 1970)
    address: "123 Medical Lane",
    pincode: "123456",
    department: "Cardiology",
    speciality: "Cardiologist",
    cabinNo: "101",
    profilephoto: "https://www.example.com/doctor-profile.jpg"  // Example image URL
)

