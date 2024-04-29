import SwiftUI

struct HealthDataView: View {
    var title: String
    var value: Double
    var unit: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text("\(value, specifier: "%.2f") \(unit)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding()
    }
}

