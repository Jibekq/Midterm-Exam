import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isEditing = false
    
    // Adding state variables to allow editing
    @State private var editedName: String = ""
    @State private var editedRole: String = ""
    @State private var editedPhoneNumber: String = ""
    @State private var editedAge: String = ""
    @State private var editedAbout: String = ""
    @State private var isLoading = false // To track the loading state while saving

    var body: some View {
        NavigationView {
            VStack {
                if let userProfile = viewModel.userProfile {
                    // Profile Picture and Edit Button
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .shadow(radius: 5)
                            .padding(.leading)

                        Spacer()

                        Button(action: {
                            if isEditing {
                                saveProfileChanges() // Save when editing ends
                            }
                            isEditing.toggle()
                        }) {
                            Text(isEditing ? "Save" : "Edit")
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 100)
                                .background(isEditing ? Color.green : Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.trailing)
                    }
                    .padding(.top)

                    // Profile Details
                    VStack(alignment: .leading, spacing: 10) {
                        profileDetailField(title: "Name:", text: isEditing ? $editedName : .constant(userProfile.name), isEditing: isEditing)
                        profileDetailField(title: "Role:", text: isEditing ? $editedRole : .constant(userProfile.role), isEditing: isEditing)
                        profileDetailField(title: "Phone:", text: isEditing ? $editedPhoneNumber : .constant(userProfile.phoneNumber ?? "Not Available"), isEditing: isEditing)
                        profileDetailField(title: "Age:", text: isEditing ? $editedAge : .constant("\(userProfile.age)"), isEditing: isEditing)
                        profileDetailField(title: "About Me:", text: isEditing ? $editedAbout : .constant(userProfile.about ?? "No information available"), isEditing: isEditing)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                    .padding()

                    // Log Out Button
                    Button(action: {
                        viewModel.logout()
                    }) {
                        Text("Log Out")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                } else if let errorMessage = viewModel.errorMessage {
                    // Show error message
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Show loading state
                    Text("Loading profile...")
                        .padding()
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                // Trigger the profile fetch when the view appears
                viewModel.fetchUserProfile()
                
                // Initialize the editable fields with the user's current profile data
                if let userProfile = viewModel.userProfile {
                    editedName = userProfile.name
                    editedRole = userProfile.role
                    editedPhoneNumber = userProfile.phoneNumber ?? ""
                    editedAge = "\(userProfile.age)"
                    editedAbout = userProfile.about ?? ""
                }
            }
        }
    }

    // Profile detail field for displaying information and allowing editing
    private func profileDetailField(title: String, text: Binding<String>, isEditing: Bool) -> some View {
        HStack {
            Text(title).bold()
            Spacer()
            if isEditing {
                TextField(title, text: text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(text.wrappedValue)
            }
        }
        .padding(.vertical, 5)
    }

    // Function to save the profile changes to the server
    private func saveProfileChanges() {
        isLoading = true

        // You might need to call an API to save the changes
       

       
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a dummy instance of AuthViewModel for the preview
        let authViewModel = AuthViewModel()
        ProfileView()
            .environmentObject(authViewModel)
    }
}
