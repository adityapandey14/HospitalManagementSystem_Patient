//
//  PrescriptionView.swift
//  Patient_HMS
//
//  Created by Arnav on 06/05/24.
//
import SwiftUI
struct PatientPrescriptionView: View {
    @EnvironmentObject var viewModel: PrescriptionViewModel
    @EnvironmentObject var xviewModel: AuthViewModel
    @State private var prescriptions: [Prescription] = []
    
    var body: some View {
        VStack {
            if prescriptions.isEmpty {
                Text("No Prescriptions Available")
                    .font(.headline)
                    .padding()
            } else {
                Text("Prescriptions for \(xviewModel.currentUser?.fullName ?? "")")
                    .font(.headline)
                    .padding()
                
                List(prescriptions, id: \.self) { prescription in
                    VStack(alignment: .leading) {
                        Text("Medicines:")
                            .font(.headline)
                        ForEach(prescription.medicines, id: \.self) { medicine in
                            Text("\(medicine.name) - \(medicine.dosage)")
                        }
                        Text("Instructions: \(prescription.instructions)")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.vertical, 5)
                }
            }
        }
        .onAppear {
            viewModel.fetchPrescriptions(for: xviewModel.currentUser?.id ?? "") { prescriptions in
                self.prescriptions = prescriptions
            }
        }
    }
}

#Preview {
    PatientPrescriptionView()
        .environmentObject(PrescriptionViewModel())
        .environmentObject(AuthViewModel())
}


