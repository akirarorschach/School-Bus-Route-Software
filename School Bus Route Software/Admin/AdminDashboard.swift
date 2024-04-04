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
        VStack {
            HStack {
                Button(action: {}) {
                    Image("menu")
                        .renderingMode(.template)
                        .foregroundColor(.white)
                }
                Spacer(minLength: 0)
            }
            
            Button(action: {}) {
                Image("profile")
                    .renderingMode(.template)
                    .foregroundColor(.white)
            }
            .padding()
            
            HStack {
                Text("Dashboard")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer(minLength: 0)
            }
            .padding()
            
            HStack(spacing: 0) {
                TabButton(selected: $tab, title: "Manage Routes", animation: animation)
                TabButton(selected: $tab, title: "Manage Personnel", animation: animation)
                TabButton(selected: $tab, title: "Manage Student Rosters", animation: animation)
            }
            .background(Color.clear)
            .clipShape(Capsule())
            .padding(.horizontal)
            
            Spacer(minLength: 0)
                .background(Color("bg").ignoresSafeArea(.all, edges: .all))
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
                        .frame(height: 45)
                        .matchedGeometryEffect(id: title, in: animation)
                }
                Text(title)
                    .foregroundColor(selected == title ? .black : .white)
                    .fontWeight(.bold)
            }
            .frame(height: 45) // Move frame here
        }
    }
}
