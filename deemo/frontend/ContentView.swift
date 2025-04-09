import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    @StateObject private var authViewModel = AuthViewModel() // ✅ Provides AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                if authViewModel.isLoggedIn {
                    DashboardView()
                        .environmentObject(authViewModel) // ✅ Ensures ProfileView has access
                } else {
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
                            Text("Welcome to the Volunteer App")
                                .font(.largeTitle)
                                .bold()
                                .padding()

                            NavigationLink(destination: LoginView()) {
                                Text("Login")
                                    .font(.title)
                                    .padding()
                                    .frame(width: 300)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            .padding(.bottom, 20)

                            NavigationLink(destination: SignUpView()) {
                                Text("Sign Up")
                                    .font(.title)
                                    .padding()
                                    .frame(width: 300)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
        }
        .environmentObject(authViewModel) // ✅ Provides AuthViewModel globally
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel()) // Inject the AuthViewModel
    }
}

