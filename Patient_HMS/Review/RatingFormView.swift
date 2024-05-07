import SwiftUI
import Firebase
import FirebaseAuth

struct RatingFormView: View {
    @StateObject private var doctorviewmodel = DoctorViewModel()
    @ObservedObject var viewModel = AppointmentViewModel()
    @ObservedObject var reviewViewModel = ReviewViewModel()
    @State private var showSubmitAlert = false
    @State private var showConfirmation = false
    @State private var rating: Int = 0
    @State private var feedback: String = ""
    let currentUserID: String

    var body: some View {
        ZStack {
            if showConfirmation {
//                Text("Thanks for your review!")
//                    .font(.headline)
//                    .padding()
                Button("Submit Another Review") {
                    showConfirmation = false
                    rating = 0
                    feedback = ""
                    viewModel.fetchAppointments() // Fetch data again to refresh
                    reviewViewModel.fetchReviewDetail() // Refresh reviews
                }
                .padding()
            } else {
                ForEach(viewModel.appointments.filter { $0.patientID == currentUserID && $0.isComplete }) { appointment in
                    if !reviewViewModel.reviewDetails.contains(where: { $0.appointmentId == appointment.id }) {
                        VStack {
                            
                            
                            
                            HStack {
                                     if let doctor = doctorviewmodel.doctorDetails.first(where: { $0.id == appointment.doctorID }) {
                                         Text(doctor.fullName)
                                             .font(.system(size: 18))
                                         Spacer()

                                         Text(appointment.date)
                                             .foregroundColor(.blue) // Use .foregroundColor instead of .foregroundStyle for simplicity
                                     } else {
                                         Text("Doctor detail not found")
                                     }
                                 }
                            .padding(.bottom)
                                 .onAppear {
                                     Task {
                                         await doctorviewmodel.fetchDoctorDetails()
                                         await doctorviewmodel.fetchDoctorDetailsByID(doctorID: appointment.doctorID)
                                     }
                                 }
                        
                         
                      
                            
                            StarRatingView(rating: $rating)
                            TextField("Enter your feedback", text: $feedback)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                            
                            Button("Submit Review") {
                                Task {
                                    try? await reviewViewModel.addReview(
                                        appointmentId: appointment.id,
                                        comment: feedback,
                                        ratingStar: rating,
                                        doctorId: appointment.doctorID
                                    )
                                    showSubmitAlert = true
                                }
                            }
                            .alert(isPresented: $showSubmitAlert) {
                                Alert(
                                    title: Text("Review Submitted"),
                                    message: Text("Your review has been posted."),
                                    dismissButton: .default(Text("Okay")) {
                                        showConfirmation = true
                                    }
                                )
                            }
                        } //VStack
                        .padding()
                      
                    }
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchAppointments() // Fetch data when the view appears
            reviewViewModel.fetchReviewDetail()
        }
    }
}

struct StarRatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
    }
}

struct AppointmentRatingView: View {
    var body: some View {
        if let currentUserUID = Auth.auth().currentUser?.uid {
            RatingFormView(currentUserID: currentUserUID)
        } else {
            Text("User not authenticated.")
        }
    }
}

struct RatingFormView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentRatingView()
    }
}
