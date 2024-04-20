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
            ZStack {
                // Background colors
                VStack(spacing: 0) {
                    // Sky blue color for the top third
                    Color.skyBlue.opacity(0.6)
                        .frame(height: geometry.size.height * 0.2) // Adjust height here
                    
                    // Gray color for the bottom two-thirds
                    Color.gray
                        .frame(height: geometry.size.height * 0.8) // Adjust height here
                }
                
                // Content
                VStack {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {}) {
                                Image("profile")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                            }
                            .padding(8)
                        }
                        Spacer()
                        
                        VStack {
                            Text("Dashboard")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                            
                            // Rest of your content here
                        }
                        
                        VStack(alignment: .leading) {
                            HStack(spacing: 0) {
                                TabButton(selected: $tab, title: "Manage Routes", animation: animation)
                                TabButton(selected: $tab, title: "Manage Personnel", animation: animation)
                                TabButton(selected: $tab, title: "Manage Student Rosters", animation: animation)
                            }
                        }
                        .background(Color.clear)
                        .clipShape(Capsule())
                        .padding(.horizontal)
                        
                        Spacer(minLength: 0)
                    }
                }
                .alignmentGuide(.top) { _ in
                    geometry.size.height * 0.4 // align content to the top
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
                        .frame(height: 30) // Adjust height here
                        .matchedGeometryEffect(id: title, in: animation)
                }
                Text(title)
                    .foregroundColor(selected == title ? .black : .white)
                    .fontWeight(.bold)
            }
            .frame(minWidth: 10, maxWidth: 200) // Adjust width here
            .padding(.horizontal, 8) // Adjust horizontal padding
        }
    }
}

