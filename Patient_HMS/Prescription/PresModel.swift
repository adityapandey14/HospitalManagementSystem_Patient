//
//  PresModel.swift
//  Patient_HMS
//
//  Created by Arnav on 06/05/24.
//

struct Prescription : Hashable{
    let patientID: String
    let medicines: [Medicine]
    let instructions: String
 
}

struct Medicine :  Hashable {
    let name: String
    let dosage: String
   
}

