import SwiftUI
import Firebase
import FirebaseFirestore

struct SearchView: View {
    @State private var searchText = ""
    @ObservedObject var departmentViewModel = DepartmentViewModel()
    @ObservedObject var doctorViewModel = DoctorViewModel.shared

    var body: some View {
        NavigationStack {
            VStack {
                // Search field for text input
                TextField("Search by Doctor Name", text: $searchText)
                    .padding(5)
                    .padding(.leading, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity)

                ScrollView {
                    ForEach(departmentViewModel.departmentTypes) { department in
                        VStack(alignment: .leading) {
                            // Get filtered doctors by department and searchText
                            let filteredDoctors = doctorViewModel.doctorDetails.filter { doctor in
                                (searchText.isEmpty || doctor.fullName.localizedCaseInsensitiveContains(searchText)) &&
                                department.specialityDetails.contains { $0.doctorId == doctor.id }
                            }

                            if !filteredDoctors.isEmpty {
                                Text("Department: \(department.departmentType)")
                                    .font(.headline)
                                    .padding(.bottom, 8)

                                ForEach(filteredDoctors, id: \.id) { doctor in
                                    NavigationLink(
                                        destination: DoctorProfile(
                                            imageUrl: doctor.profilephoto ?? "default_url", // Provide a valid default
                                            fullName: doctor.fullName,
                                            specialist: doctor.speciality,
                                            doctor: doctor
                                        )
                                    ) {
                                        HStack {
                                            Image(systemName: "person.circle.fill")
                                                .foregroundColor(.blue)
                                            Text(doctor.fullName)
                                                .padding()
                                            Spacer()
                                        }
                                        Divider()
                                    }
                                }
                            }
                        }
                        .padding()
                        .onAppear {
                            if department.specialityDetails.isEmpty {
                                departmentViewModel.fetchSpecialityOwnerDetails(for: department.id)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.white) // Consistent background color
            .navigationTitle("Search Doctors")
        }
        .onAppear {
            departmentViewModel.fetchDepartmentTypes()
            Task {
                await doctorViewModel.fetchDoctorDetails() // Async data fetching
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
