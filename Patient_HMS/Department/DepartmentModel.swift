//
//  DepartmentModel.swift
//  Patient_HMS
//
//  Created by Aditya Pandey on 22/04/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct DepartmentDetail: Identifiable, Equatable, Hashable {
    var id: String
    var specialityDetails: [SpecialityDetail] = []
    var isAscendingOrder: Bool = true
    
    static func == (lhs: DepartmentDetail, rhs: DepartmentDetail) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SpecialityDetail: Identifiable, Codable, Hashable {
    var id: String
    var doctorId: String
    var fees: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class DepartmentViewModel: NSObject, ObservableObject {
    @Published var departmentTypes: [DepartmentDetail] = []
    static let shared = DepartmentViewModel()
    private let db = Firestore.firestore()
    
    override init() {
        super.init()
     fetchDepartmentTypes()
    }
    

    func fetchDepartmentTypes() {
        Task {
            do {
                let querySnapshot = try await db.collection("department").getDocuments()
                DispatchQueue.main.async {
                    self.departmentTypes = querySnapshot.documents.map { document in
                        DepartmentDetail(id: document.documentID)
                    }
                }
            } catch {
                print("Error fetching Department types: \(error.localizedDescription)")
            }
        }
    }  //End of the function
    
    func fetchSpecialityOwnerDetails(for departmentType: DepartmentDetail) {
        Task {
            do {
                // Fetch documents from Firestore
                let querySnapshot = try await db
                    .collection("department")
                    .document(departmentType.id)
                    .collection("speciality")
                    .getDocuments()

                // Convert documents to SpecialityDetail
                let details = querySnapshot.documents.compactMap { document in
                    let data = document.data()
                    return SpecialityDetail(
                        id: document.documentID,
                        doctorId: data["doctorId"] as? String ?? "",
                        fees: data["fees"] as? Int ?? 0
                    )
                }

                // Find the matching department and update its speciality details
                DispatchQueue.main.async {
                    if let index = self.departmentTypes.firstIndex(where: { $0.id == departmentType.id }) {
                        self.departmentTypes[index].specialityDetails = details
                    }
                }
            } catch {
                print("Error fetching speciality owner details: \(error.localizedDescription)")
            }
        }
    }// end of the function
    
    
    func sortDetailsAscending(for departmentType: DepartmentDetail) {
           if let index = departmentTypes.firstIndex(where: { $0.id == departmentType.id }) {
               // Sort the specialityDetails by fees in ascending order
               departmentTypes[index].specialityDetails.sort { $0.fees < $1.fees }
               departmentTypes[index].isAscendingOrder = true
           }
       }

       // Method to sort speciality details in descending order by fees
       func sortDetailsDescending(for departmentType: DepartmentDetail) {
           if let index = departmentTypes.firstIndex(where: { $0.id == departmentType.id }) {
               // Sort the specialityDetails by fees in descending order
               departmentTypes[index].specialityDetails.sort { $0.fees > $1.fees }
               departmentTypes[index].isAscendingOrder = false
           }
       }
}



struct DepartmentModel: View {
    @ObservedObject var viewModel = DepartmentViewModel()
    @State private var selectedDepartmentType: DepartmentDetail?
    var body: some View {
        ScrollView {
            
            ForEach(viewModel.departmentTypes) { deptTypes in
                VStack(alignment: .leading) {
                    Text("Department Type: \(deptTypes.id)")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .onTapGesture {
                            selectedDepartmentType = deptTypes
                            viewModel.fetchSpecialityOwnerDetails(for: deptTypes)
                        }
                        
                    HStack {
                        Button("Sort Ascending") {
                            viewModel.sortDetailsAscending(for: deptTypes)
                        }
                        .frame(width: 150, height: 30)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    
                        Button("Sort Descending") {
                            viewModel.sortDetailsDescending(for: deptTypes)
                        }
                        .frame(width: 150, height: 30)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                
                    ForEach(deptTypes.specialityDetails) { detail in
                        Text("Speciality : \(detail.id)")
                        VStack(alignment: .leading) {
                         Text("DoctorId: \(detail.doctorId)")
                         .padding()
                         Text("Consulatant Fees: \(detail.fees)")
                          .padding()

                        }
                    }
                } //End of the VStack
                
            } //End of the for loop
            
        }// End of the ScrollView
      
    }
}

#Preview {
    DepartmentModel()
}




