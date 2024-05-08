//
//  TopFive.swift
//  Patient_HMS
//
//  Created by Aditya Pandey on 08/05/24.
//


import SwiftUI
import Firebase
import FirebaseFirestore

class TopRatedDoctorsViewModel: ObservableObject {
    @Published var topRatedDoctors: [DoctorModel] = []
    private let db = Firestore.firestore()

    func fetchTopFiveRatedDoctors() {
        Task {
            do {
                // Step 1: Fetch all reviews and group by doctorId to calculate average ratings
                let reviewSnapshot = try await db.collection("review").getDocuments()

                // Step 2: Group by doctorId and calculate average rating
                var doctorRatings: [String: [Int]] = [:]
                for document in reviewSnapshot.documents {
                    let data = document.data()
                    let doctorId = data["doctorId"] as? String ?? ""
                    let ratingStar = data["ratingStar"] as? Int ?? 0
                    if doctorRatings[doctorId] == nil {
                        doctorRatings[doctorId] = []
                    }
                    doctorRatings[doctorId]?.append(ratingStar)
                }

                // Calculate average ratings for each doctor
                var doctorAverageRatings: [(doctorId: String, averageRating: Double)] = []
                for (doctorId, ratings) in doctorRatings {
                    let total = ratings.reduce(0, +)
                    let average = Double(total) / Double(ratings.count)
                    doctorAverageRatings.append((doctorId, average))
                }

                // Step 3: Sort doctors by average rating in descending order and take the top 5
                let topFiveDoctors = doctorAverageRatings
                    .sorted { $0.averageRating > $1.averageRating }
                    .prefix(5)

                // Step 4: Fetch doctor details for the top five
                var topDoctors: [DoctorModel] = []
                for topDoctor in topFiveDoctors {
                    let doctorSnapshot = try await db.collection("doctor").document(topDoctor.doctorId).getDocument()
                    if doctorSnapshot.exists {
                        let data = doctorSnapshot.data()!
                        let doctor = DoctorModel(
                            id: doctorSnapshot.documentID,
                            fullName: data["fullName"] as? String ?? "",
                            descript: data["descript"] as? String ?? "",
                            gender: data["gender"] as? String ?? "",
                            mobileno: data["mobileno"] as? String ?? "",
                            experience: data["experience"] as? String ?? "",
                            qualification: data["qualification"] as? String ?? "",
                            address: data["address"] as? String ?? "",
                            pincode: data["pincode"] as? String ?? "",
                            department: data["department"] as? String ?? "",
                            speciality: data["speciality"] as? String ?? "",
                            cabinNo: data["cabinNo"] as? String ?? "",
                            profilephoto: data["profilephoto"] as? String
                        )
                        topDoctors.append(doctor)
                    }
                }

                // Step 5: Update the observable object with the top doctors list
                DispatchQueue.main.async {
                    self.topRatedDoctors = topDoctors
                }
            } catch {
                print("Error fetching top-rated doctors: \(error.localizedDescription)")
            }
        }
    }
}

// Usage example: Fetching top-rated doctors and displaying their names
struct TopFive: View {
    @ObservedObject var topratedDoctorviewModel = TopRatedDoctorsViewModel()

    var body: some View {
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
       }
   }



#Preview {
    TopFive()
}
