import SwiftUI
import Combine

// Make sure UserProfile is imported if it's in a separate file or module
// import UserProfileModule

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    @Published var userProfile: UserProfile?

    private var cancellables = Set<AnyCancellable>()

    func login(email: String, password: String) {
        guard let url = URL(string: "http://localhost:5500/api/auth/login") else {
            DispatchQueue.main.async { self.errorMessage = "Invalid URL" }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                    self.isLoggedIn = false
                }
            }, receiveValue: { response in
                UserDefaults.standard.set(response.token, forKey: "authToken")
                self.isLoggedIn = true
                self.fetchUserProfile() // Fetch the user profile after login
            })
            .store(in: &cancellables)
    }

    func fetchUserProfile() {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            DispatchQueue.main.async { self.errorMessage = "No token found" }
            return
        }

        guard let url = URL(string: "http://localhost:5500/api/profile") else {
            DispatchQueue.main.async { self.errorMessage = "Invalid profile URL" }
            return
        }

        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: UserProfile.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = "Error fetching profile: \(error.localizedDescription)"
                    // Only log out if the error is due to invalid token/session
                    self.isLoggedIn = false
                }
            }, receiveValue: { userProfile in
                self.userProfile = userProfile
                // No need to reset isLoggedIn here, as the profile fetch is separate from login state.
            })
            .store(in: &cancellables)
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        self.userProfile = nil
        self.isLoggedIn = false
    }
}

struct LoginResponse: Decodable {
    let token: String
}
