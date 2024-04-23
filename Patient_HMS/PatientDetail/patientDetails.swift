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
            Form {
                Section(header: Text("Patient Profile")) {
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
                                                                .fill(Color(hue: 1.0, saturation: 0.0, brightness: 0.867))
                                                                .frame(width: 100, height: 100)
                                                                .overlay(
                                                                    Image(systemName: "camera.fill")
                                                                        .resizable()
                                                                        .frame(width: 50, height: 40)
                                                                        .foregroundStyle(Color.black)
                                                                )
                                                        }
                                                    }
                                                    .sheet(isPresented: $isImagePickerPresented) {
                                                        ImageP(posterImage: $posterImage, defaultPoster: defaultposterImage)
                                                    }
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    HStack {
                        Text("Full Name: ")
                        TextField("Name", text: $profileViewModel.currentProfile.fullName)
                    }
                    .padding(.bottom, 15.0)
                    
          
                    
                    HStack {
                                Text("Mobile Number: ")
                                TextField("Enter Mobile Number", text: $profileViewModel.currentProfile.mobileno)
                                    .keyboardType(.numberPad)
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
                                Text("Emergency Contact: ")
                                TextField("Enter Emergency Contact", text: $profileViewModel.currentProfile.emergencycontact)
                                    .keyboardType(.numberPad)
                            }
                    .padding(.bottom, 15.0)
                    
                    HStack {
                        DatePicker("Date of Birth", selection: $profileViewModel.currentProfile.dob,
                                   in: Date()..., displayedComponents: [.date])
                    }
                    .padding(.bottom, 15.0)
                    
                    HStack {
                        Text("Address: ")
                        TextField("Your Address", text: $profileViewModel.currentProfile.address)
                    }
                    .padding(.bottom, 15.0)
                    
                    HStack {
                                Text("Pincode: ")
                        TextField("Enter Pincode", text: $profileViewModel.currentProfile.pincode)
                                    .keyboardType(.numberPad)
                            }
                    .padding(.bottom, 15.0)
                    
                
//                    Section(header: Text("Upload Health Records")) {
//                                        Button("Upload PDF") {
//                                            // Present document picker to select PDF
//                                            isImagePickerPresented.toggle()
//                                        }
//                                        .sheet(isPresented: $isImagePickerPresented) {
//                                            DocumentPicker(documentTypes: [UTType.pdf.identifier], handleResult: handlePDFSelection)
//                                        }
//                                        
//                                        // Display selected PDF filename
//                                        if let selectedPDFName = selectedPDFName {
//                                            Text("Uploaded PDF: \(selectedPDFName)")
//                                        }
//                                    }
                                }
            }
            
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
                    .foregroundColor(.blue)
                    .padding()
            }
            .background(
                NavigationLink(
                    destination: Homepage(),
                    isActive: $navigationLinkIsActive,
                    label: { EmptyView() }
                )
            )
            .buttonStyle(.bordered)
            .tint(.blue)
            .padding()

            
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Create Your Profile")
        .padding(.horizontal, 7)
    }
}


