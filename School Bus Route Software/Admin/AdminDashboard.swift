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
                Color.skyBlue.opacity(0.8)
                    .frame(height: geometry.size.height * 0.2) // Set height to 20% of the parent view height
                
                // Profile button with vertically centered alignment within the blue banner
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image("profile")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    .padding(.top, (geometry.size.height * 0.2 - 80) / 2) // Adjust top padding to vertically center the profile icon
                    .padding(.trailing, 12)
                }
                
                VStack(spacing: 0) {
                    // Dashboard text with black color and larger size
                    Text("Welcome, Sushanth!")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .padding()
                    
                    Spacer()
                    
                    // Buttons
                    HStack {
                        Spacer()
                        TabButton(selected: $tab, title: "Manage Routes", animation: animation)
                            .frame(height: 40)
                        TabButton(selected: $tab, title: "Manage Users", animation: animation)
                            .frame(height: 40)
                        TabButton(selected: $tab, title: "Manage Student Rosters", animation: animation)
                            .frame(height: 40)
                        Spacer()
                    }
                    .padding()
                }
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
