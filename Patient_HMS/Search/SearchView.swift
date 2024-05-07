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
//                            Text("Department: \(department.departmentType)")
//                                .font(.headline)
//                                .padding(.bottom, 8)

                            ForEach(
                                department.specialityDetails.compactMap { detail in
                                    doctorViewModel.doctorDetails.first { doctor in
                                        searchText.isEmpty ||
                                        doctor.fullName.localizedCaseInsensitiveContains(searchText)
                                    }
                                },
                                id: \.id
                            ) { doctorDetail in
                                NavigationLink(destination: DoctorDetailView(doctor: doctorDetail)) {
                                    HStack {
                                        Image(systemName: "person.circle.fill")
                                            .foregroundColor(.blue)
                                        Text("\(doctorDetail.fullName)")
                                            .padding()
                                        Spacer()
                                    }
                                    .foregroundColor(.primary)
                                    Divider()
                                }
                            }
                        }
                        .padding()
                        .onAppear {
                            departmentViewModel.fetchSpecialityOwnerDetails(for: department.id)
                        }
                    }
                }
                .onAppear {
                    departmentViewModel.fetchDepartmentTypes() // Fetch department types when view appears
                    Task {
                        await doctorViewModel.fetchDoctorDetails() // Async data fetching
                    }
                }
            }
            .padding()
            .background(Color.white) // Consistent background color
            .navigationTitle("Search Doctors")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
