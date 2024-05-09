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
//                            .padding(.top)
                .background(Color(uiColor: .secondarySystemBackground))
                .foregroundStyle(Color("accentBlue"))
                .cornerRadius(8)
            } else {
                ForEach(viewModel.appointments.filter { $0.patientID == currentUserID && $0.isComplete }) { appointment in
                    if !reviewViewModel.reviewDetails.contains(where: { $0.appointmentId == appointment.id }) {
                        VStack {
                            Text("Reviews")
//                                .font(.headline)
                                .bold()
                                .padding(.bottom, 30)
                                .padding(.trailing, 235)
                                .font(.system(size: 30))
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(uiColor: .secondarySystemBackground))
                                    .frame(width: 360, height: 60)
                            HStack {
                                
                                if let doctor = doctorviewmodel.doctorDetails.first(where: { $0.id == appointment.doctorID }) {
                                    Text("Name: \(doctor.fullName)")
//                                        .padding()
                                        .font(.system(size: 18))
//                                        .padding(.trailing, 110)
                                        .padding(.leading, 15)
                                        .padding(.top)
                                    Spacer()
                                    
                                    Text("Date: \(appointment.date)")
                                        .padding(.trailing, 15)
                                        .padding(.top)
//                                        .padding()
//                                        .foregroundColor(Color(")) // Use .foregroundColor instead of .foregroundStyle for simplicity
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
                        }
                        
                         
                      
                            
                            StarRatingView(rating: $rating)
                                .padding()
                            TextField("Enter your feedback", text: $feedback)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                                .padding(.bottom)
                            
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
                            .padding()
//                            .padding(.top)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .foregroundStyle(Color("accentBlue"))
                            .cornerRadius(8)

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
        .padding(.bottom, 300)
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
