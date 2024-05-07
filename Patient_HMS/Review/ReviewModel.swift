//
//  ReviewModel.swift
//  Patient_HMS
//
//  Created by Aditya Pandey on 24/04/24.
//


import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine



struct ReviewData :  Identifiable, Codable ,  Equatable {
    var id : String
    var comment : String
    var patientId : String
    var doctorId : String
    var ratingStar : Int
}


class ReviewViewModel : ObservableObject {
    @Published var reviewDetails = [ReviewData]()
    private let db = Firestore.firestore()
    static let shared = ReviewViewModel()
    
    init() {
        // Initialize the view model asynchronously
        fetchReviewDetail()
    }
    
    func fetchReviewDetail() {
        Task {
            do {
                let snapshot = try await db.collection("review").getDocuments()
                DispatchQueue.main.async {
                    var details: [ReviewData] = []
                    for document in snapshot.documents {
                        let data = document.data()
                        let id = document.documentID
                        let comment = data["comment"] as? String ?? ""
                        let patientId = data["patientId"] as? String ?? ""
                        let doctorId = data["doctorId"] as? String ?? ""
                        let ratingStar = data["ratingCount"] as? Int ?? 0
                        
                        let reviewDetail = ReviewData(id: id,
                                                      comment: comment,
                                                      patientId: patientId,
                                                      doctorId: doctorId,
                                                      ratingStar: ratingStar
                                                     )
                        details.append(reviewDetail)
                    }
                    self.reviewDetails = details
                }
            } catch {
                print("Error fetching review details: \(error.localizedDescription)")
            }
        }
    }
}

struct ReviewModel: View {
    @ObservedObject var reviewViewModel = ReviewViewModel()
    @State private var isFetching = false
    var body: some View {
        NavigationStack{
          
            
            HStack{
                let reviewsForSkillOwner = reviewViewModel.reviewDetails.filter { $0.doctorId == "1" }
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
            .padding()

            .font(AppFont.smallReg)
            .onAppear() {
                reviewViewModel.fetchReviewDetail()
                }
            
            
        } //End of the Navigation View
    }
}

#Preview {
    ReviewModel()
}




//HStack{
//    let reviewsForSkillOwner = reviewViewModel.reviewDetails.filter { $0.teacherUid == teacherUid && $0.skillOwnerDetailsUid == skillOnwerDetailsUid }
//
//    if !reviewsForSkillOwner.isEmpty {
//        let averageRating = reviewsForSkillOwner.reduce(0.0) { $0 + Double($1.ratingStar) } / Double(reviewsForSkillOwner.count)
//
//        Text("\(averageRating, specifier: "%.1f") ⭐️")
////                                .padding([.top, .bottom], 3)
////                                .padding([.leading, .trailing], 9)
////                                .background(Color.background)
////                                .cornerRadius(50)
//            .font(AppFont.smallReg)
//
//        Text("\(reviewsForSkillOwner.count) Review\(reviewsForSkillOwner.count == 1 ? "" : "s")")
//            .font(AppFont.smallReg)
//    } else {
//        Text("no reviews")
//            .font(AppFont.smallReg)
//            .foregroundColor(.black).opacity(0.3)
////                                .padding(.bottom)
//    }
//    Spacer()
//}
//.padding(.bottom, 4)
////                    .padding(.top, 1)
//.font(AppFont.smallReg)
//.onAppear() {
//        ReviewDetails().fetchReviewDetails()
//    }
