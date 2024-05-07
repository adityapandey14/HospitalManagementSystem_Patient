//
//  Medicine_Model.swift
//  Patient_HMS
//
//  Created by Arnav on 07/05/24.
//

import Foundation
struct Medicines: Identifiable, Codable {
    var id: String? 
    var name: String
    var dosage: String
    var times: [String]
    var daysOfWeek: [String]
    var startDate: Date 
    var endDate: Date
}
