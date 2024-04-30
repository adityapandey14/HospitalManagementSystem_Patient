//
//  DoctorModel.swift
//  Patient_HMS
//
//  Created by Arnav on 30/04/24.
//

import Foundation
import SwiftUI


struct DoctorModel: Equatable, Codable{
    
    var id: String
    var name: String
    var department: String
    var email:String
    var contact:String
    var experience:String
    var employeeID:String
    var image: String?
    var specialisation:String
    var degree: String
    var cabinNumber: String
    
}


