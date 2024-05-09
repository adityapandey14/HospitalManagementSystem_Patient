import SwiftUI

struct HealthDataView: View {
    var imageName: String // Changed from Image to String to store the name of the image asset
    var value: Double
    var unit: String
    var imageColor: Color
    
    var body: some View {
        HStack{
            Spacer()
            VStack(spacing: 15) {
                    Image(systemName: imageName) // Using SF Symbols, you can replace it with Image(imageName) if using custom images
                    .font(.system(size: 26))
                        .fontWeight(.medium)
                        .foregroundStyle(imageColor)
                        .opacity(0.9)
                    Text("\(value, specifier: "%.2f") \(unit)")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
//            .padding(.horizontal)
            Spacer()
        }
//            .background(Color.primary)
//            .cornerRadius(10)
//            .padding()
            //Spacer()
        
        
    }
}

