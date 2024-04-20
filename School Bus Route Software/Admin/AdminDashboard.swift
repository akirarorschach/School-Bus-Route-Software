//God bless our debugging tools!

import SwiftUI

struct AdminDashboard_Previews: PreviewProvider {
    static var previews: some View {
        AdminDashboard()
            .preferredColorScheme(.dark)
            .navigationTitle("")
    }
}

struct AdminDashboard: View {
    
    @State var tab = "Manage Routes"
    @Namespace var animation
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                // Darker blue banner
                Color.skyBlue.opacity(0.8) // Increased opacity for a darker shade
                    .frame(height: geometry.size.height * 0.2)
                    .alignmentGuide(.top) { _ in geometry.size.height * 0.2 } // Align the blue banner to the top
                
                // Profile button with vertically centered alignment within the blue banner
                .overlay(
                    HStack {
                        Spacer()
                        // Profile button with vertically centered alignment within the blue banner
                        Button(action: {}) {
                            Image("profile")
                                .resizable()
                                .frame(width: 80, height: 80) // Adjust size as needed
                                .foregroundColor(.white)
                        }
                        .padding(12) // Increased padding
                    }
                )
                
                // Dashboard text with black color and larger size
                VStack(alignment: .leading) {
                    Text("Dashboard")
                        .font(.system(size: 30, weight: .bold)) // Increased font size
                        .foregroundColor(.black) // Set color to black
                        .padding()
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                
                // Lower half with white background and opacity 0.8
                Color.white.opacity(0.8)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.8) // Adjust height here
                    .alignmentGuide(.top) { _ in geometry.size.height * 0.2 } // Align the top of the white background with the bottom of the blue banner
                    .offset(y: geometry.size.height * 0.2) // Offset the white background below the blue banner
                
                // Buttons
                HStack {
                    Spacer()
                    TabButton(selected: $tab, title: "Manage Routes", animation: animation)
                        .frame(height: 40) // Increased button height
                    TabButton(selected: $tab, title: "Manage Users", animation: animation)
                        .frame(height: 40) // Increased button height
                    TabButton(selected: $tab, title: "Manage Student Rosters", animation: animation)
                        .frame(height: 40) // Increased button height
                    Spacer()
                }
                .padding()
            }
        }
    }
}



struct TabButton: View {
    @Binding var selected: String
    var title: String
    var animation: Namespace.ID
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selected = title
            }
        }) {
            ZStack {
                if selected == title {
                    Capsule()
                        .fill(Color.white)
                        .frame(height: 40) // Adjust height here
                        .matchedGeometryEffect(id: title, in: animation)
                }
                Text(title)
                    .foregroundColor(selected == title ? .black : .white)
                    .font(.system(size: 20, weight: .bold)) // Increased font size
            }
            .frame(minWidth: 10, maxWidth: 200) // Adjust width here
            .padding(.horizontal, 16) // Increased horizontal padding
        }
    }
}
