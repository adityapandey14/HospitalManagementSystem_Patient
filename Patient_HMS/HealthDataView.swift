import SwiftUI

struct HealthDataView: View {
    var imageName: String // Changed from Image to String to store the name of the image asset
    var value: Double
    var unit: String
    var imageColor: Color
    
    var body: some View {
        VStack(spacing: 15) {
                Image(systemName: imageName) // Using SF Symbols, you can replace it with Image(imageName) if using custom images
                    .font(.title)
                    .foregroundStyle(imageColor)
                Text("\(value, specifier: "%.2f") \(unit)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
//            .background(Color.primary)
//            .cornerRadius(10)
//            .padding()
            //Spacer()
        
        
    }
}

