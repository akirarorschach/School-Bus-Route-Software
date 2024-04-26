import SwiftUI

struct LoginView: View {
    
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var loggedIn: Bool = false
    @State private var isSigningIn: Bool = false
    @State private var isActive: Bool = false
    
    var isSignInButtonDisabled: Bool {
        [name, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("School Bus Route Software")
                .font(.title)
                .multilineTextAlignment(.center)
                .bold()
            
            Text("Student transportation route management software")
                .multilineTextAlignment(.center)
            
            TextField("Name",
                      text: $name ,
                      prompt: Text("Login").foregroundColor(.blue)
            )
            .padding(10)
            .padding(.horizontal)

            HStack {
                if showPassword {
                    TextField("Password",
                              text: $password,
                              prompt: Text("Password").foregroundColor(.red))
                        .padding(10)
                } else {
                    SecureField("Password",
                                text: $password,
                                prompt: Text("Password").foregroundColor(.red))
                        .padding(10)
                }

                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal)

            Button(action: {
                // Set isSigningIn to true to display "Signing in..."
                isSigningIn = true
                
                // Delay the transition to AdminDashboard
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    // Set loggedIn to true after 2 seconds to trigger navigation
                    loggedIn = true
                    print("Logged in: \(loggedIn)")
                    
                    // Activate the NavigationLink immediately
                    isActive = true
                }
            }) {
                if isSigningIn {
                    Text("Signing in...")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                } else {
                    Text("Sign In")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                isSignInButtonDisabled ?
                LinearGradient(gradient: Gradient(colors: [.gray]), startPoint: .topLeading, endPoint: .bottomTrailing) :
                    LinearGradient(gradient: Gradient(colors: [.blue, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(20)
            .disabled(isSignInButtonDisabled || isSigningIn)
            .padding()
            
            .navigationTitle("Login")
            
            // Direct NavigationLink, navigate when loggedIn is true
            NavigationLink(
                destination: AdminDashboard(),
                isActive: $isActive, // Activate the NavigationLink immediately
                label: { EmptyView() }
            )
            
            Spacer() // Add spacer to push content to the top
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
