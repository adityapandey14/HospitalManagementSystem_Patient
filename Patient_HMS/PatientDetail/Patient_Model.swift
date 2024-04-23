//
//  Patient_Model.swift
//  Patient_HMS
//
//  Created by Arnav on 22/04/24.
//

import Foundation
import SwiftUI

struct HealthRecord: Equatable, Codable{
    var filename: String
    var downloadURL: String
}
struct PatientM: Equatable, Codable{
    
    var fullName : String
    var gender: String
    var mobileno: String
    var bloodgroup:String
    var emergencycontact:String
    var dob:Date
    var address:String
    var pincode:String
    var profilephoto: String?
    
}
