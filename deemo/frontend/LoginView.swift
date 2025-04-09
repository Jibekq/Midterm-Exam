import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.teal
                    .ignoresSafeArea()

                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))

                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)

                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding()

                    // Email TextField
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)

                    // Password SecureField
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)

                    // Error message if credentials are wrong
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }

                    // Submit Button
                    Button(action: {
                        loginUser()
                    }) {
                        Text(isLoading ? "Logging in..." : "Submit")
                            .font(.title2)
                            .padding()
                            .frame(width: 200)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(isLoading) // Disable the button when loading

                    // Navigation to Dashboard after login
                    NavigationLink(
                        destination: DashboardView(),
                        isActive: $viewModel.isLoggedIn
                    ) {
                        EmptyView()
                    }
                    
                    // Link to Sign Up page
                    NavigationLink(destination: SignUpView()) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                errorMessage = "" // Reset error message when view appears
            }
        }
    }

    func loginUser() {
        errorMessage = "" // Reset error message
        isLoading = true  // Start loading

        viewModel.login(email: email, password: password)

        // After 1.5 seconds, check if login is successful
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if !viewModel.isLoggedIn {
                errorMessage = viewModel.errorMessage ?? "Login failed"
            }
            isLoading = false
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
