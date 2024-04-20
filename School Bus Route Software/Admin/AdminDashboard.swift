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
        ZStack {
            Color.skyBlue.opacity(0.6).ignoresSafeArea(.all, edges: .all)
            
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
                
                HStack {
                    Text("Dashboard")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer(minLength: 0)
                }
                .padding()
                
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

