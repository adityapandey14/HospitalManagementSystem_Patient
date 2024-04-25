import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseStorage

class PatientViewModel: ObservableObject {
   
    @Published var currentProfile: PatientM = PatientM(
        fullName: "\(AuthViewModel().currentUser?.fullName )",
        gender: "",
        mobileno: "",
        bloodgroup: "",
        emergencycontact:"",
        dob:Date(),
        address:"",
        pincode:"",
        profilephoto: nil
    )
    private let db = Firestore.firestore()
    @EnvironmentObject var viewModel: AuthViewModel
    
    func fetchProfile(userId: String?) {
        guard let userId = userId, !userId.isEmpty else {
            print("Invalid userId")
            return
        }
        
        db.collection("patient").document(userId).getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                if let document = document, document.exists {
                    do {
                        self.currentProfile = try document.data(as: PatientM.self)
                    } catch {
                        print("Error decoding Profile: \(error)")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }

    
    
    func updateProfile(_ profile: PatientM, posterImage: UIImage?, userId: String?, completion: @escaping () -> Void) {
        var updatedProfile = profile
        
        // Check if there is a new profile photo to upload
        if let image = posterImage, let imageData = image.jpegData(compressionQuality: 0.1) {
            let storageRef = Storage.storage().reference().child("profilephoto").child(UUID().uuidString)
            
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print("Error getting download URL: \(error?.localizedDescription ?? "")")
                        return
                    }
                    
                    updatedProfile.profilephoto = downloadURL.absoluteString
                    
                    self.updateProfileDocument(updatedProfile, userId: userId, completion: completion)
                }
            }
        } else {
            // No new profile photo to upload, directly update profile document
            updateProfileDocument(updatedProfile, userId: userId, completion: completion)
        }
    }

    func updateProfileDocument(_ profile: PatientM, userId: String?, completion: @escaping () -> Void) {
        guard let userId = userId else {
            print("User ID is nil")
            return
        }
        
        let profileRef = self.db.collection("patient").document(userId)
        
        do {
            try profileRef.setData(from: profile, merge: true) { error in
                if let error = error {
                    print("Error updating profile document: \(error.localizedDescription)")
                } else {
                    print("Profile document updated successfully!")
                    self.fetchProfile(userId: userId)
                    completion()
                }
            }
        } catch {
            print("Error updating profile document: \(error.localizedDescription)")
        }
    }

    
   

}
