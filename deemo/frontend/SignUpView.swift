import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isActive = false
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var navigateToLogin = false
    
    var body: some View {
        ZStack {
            Color.teal.ignoresSafeArea()
            
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            
            Circle()
                .scale(1.8)
                .foregroundColor(.white)
            
            VStack {
                Text("Sign Up")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                TextField("Full Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button(action: signUpUser) {
                        Text("Sign Up")
                            .font(.title2)
                            .padding()
                            .frame(width: 200)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(isLoading)  // Disable the button when loading
                }
                
                NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                    EmptyView()
                }
                
                NavigationLink(destination: LoginView()) {
                    Text("Already have an account? Login")
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
            }
            .padding()
        }
    }
    
    func signUpUser() {
        errorMessage = ""
        
        // Check for empty fields
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        // Check if passwords match
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        // Validate email format
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return
        }
        
        isLoading = true
        
        // ✅ Using the correct backend URL
        guard let url = URL(string: "http://localhost:5500/api/auth/signup") else {
            errorMessage = "Invalid server URL"
            isLoading = false
            return
        }
        
        let user = ["name": name, "email": email, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: user) else {
            errorMessage = "Failed to encode data"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, (200...201).contains(httpResponse.statusCode) {
                    // On successful signup
                    navigateToLogin = true
                } else {
                    let responseMessage = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Unknown error"
                    errorMessage = responseMessage
                }
            }
        }.resume()
    }
    
    // Helper function to validate email format
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()
        SignUpView().environmentObject(authViewModel)
    }
}
