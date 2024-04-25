import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

struct Profile_Create: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var profileViewModel: PatientViewModel
    @State private var navigationLinkIsActive = false
    let email:String
    let password:String
    let fullName:String
    @State private var isImagePickerP = false
    @State private var isImagePickerPresented = false
    @State private var posterImage : UIImage?
    @State private var defaultposterImage : UIImage = UIImage(named: "default_hackathon_poster")!
    let genders = ["Male", "Female", "Other"]
    let bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    @State private var healthRecordPDFs: [Data] = [] // Array to store PDF data
        @State private var selectedPDFName: String? = nil // Store selected PDF name
        
//        private func handlePDFSelection(result: Result<URL, Error>) {
//            if case let .success(url) = result {
//                do {
//                    // Convert PDF to Data
//                    let pdfData = try Data(contentsOf: url)
//                    healthRecordPDFs.append(pdfData)
//                    // Get selected PDF name
//                    selectedPDFName = url.lastPathComponent
//                } catch {
//                    print("Error converting PDF to data: \(error)")
//                }
//            }
//        }
    var body: some View {
        VStack {
            Form{
                VStack{
                    // CameraButton
                    HStack {
                        Spacer()
                        Button(action: {
                            isImagePickerPresented.toggle()
                        }) {
                            if let posterImage = posterImage {
                                Image(uiImage: posterImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                            } else {
                                Circle()
                                    .fill(Color.solitude)
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Image(systemName: "camera.fill")
                                            .resizable()
                                            .frame(width: 50, height: 40)
                                            .foregroundStyle(Color.gray)
                                    )
                            }
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImageP(posterImage: $posterImage, defaultPoster: defaultposterImage)
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .background(Color.solitude)
                }
                .padding()
                VStack{
                    
                        
                        
                    HStack {
                        TextField("Enter Mobile Number", text: $profileViewModel.currentProfile.mobileno)
                            .keyboardType(.numberPad)
                            .underlineTextField()
                            
                    }
                    .padding(.bottom, 15.0)
                    
                    HStack {
                        DatePicker("Date of Birth", selection: $profileViewModel.currentProfile.dob,
                                   in: ...Date(),
                                   displayedComponents: [.date])
                    }
                    .padding(.bottom, 15.0)

                    
                    HStack{
                        Picker("Select Gender", selection: $profileViewModel.currentProfile.gender) {
                            ForEach(genders, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }.padding(.bottom, 15.0)
                    
                    HStack{
                        Picker("Select Blood Group", selection: $profileViewModel.currentProfile.bloodgroup) {
                            ForEach(bloodGroups, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }.padding(.bottom, 15.0)
                    
                    HStack {
                        TextField("Your Address", text: $profileViewModel.currentProfile.address)
                            .underlineTextField()
                    }
                    .padding(.bottom, 15.0)

                    
                    HStack {
                        TextField("Enter Pincode", text: $profileViewModel.currentProfile.pincode)
                            .keyboardType(.numberPad)
                            .underlineTextField()
                    }
                    .padding(.bottom, 15.0)
                    
                    HStack {
                        TextField("Enter Emergency Contact", text: $profileViewModel.currentProfile.emergencycontact)
                            .keyboardType(.numberPad)
                            .underlineTextField()
                    }
                    .padding(.bottom, 15.0)
                    
                }
                HStack{
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.createUser(withEmail: email, password: password, fullName: fullName)
                            
                                profileViewModel.updateProfile(profileViewModel.currentProfile, posterImage: posterImage ?? defaultposterImage, userId: viewModel.currentUser?.id) {
                                }
                            } catch {
                                
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        Text("Get Started")
                            .foregroundColor(.buttonForeground)
                            .frame(width: 300, height: 30)
                            .padding()
                            .background(Color.midNightExpress)
                            .cornerRadius(10)
                    }
                    .background(
                    NavigationLink(
                            destination: Homepage(),
                            isActive: $navigationLinkIsActive,
                            label: { EmptyView() }
                        )
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Create Your Profile")
        }
        .padding(10)
    }
}

struct Profile_Create_Previews: PreviewProvider {
    static var previews: some View {
        Profile_Create(email: "", password: "", fullName: "")
            .environmentObject(AuthViewModel())
            .environmentObject(PatientViewModel())
    }
}

