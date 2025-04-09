import SwiftUI

struct AnnouncementView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            // Announcement Title
            Text("Exciting Update: New Features Coming Soon!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.top, 20)
            
            // Announcement Details
            VStack(alignment: .leading, spacing: 10) {
                Text("We are thrilled to announce the release of several new features for our Volunteer Management App! These updates are designed to make managing volunteers easier and more efficient.")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("Here’s what you can expect:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // List of features
                VStack(alignment: .leading, spacing: 8) {
                    Text("• Enhanced Volunteer Tracking: Keep track of hours more accurately.")
                    Text("• New Categories for Volunteer Opportunities: Filter by cause (e.g., environment, aged people, animals).")
                    Text("• Improved Admin Dashboard: Generate detailed reports and manage volunteers effortlessly.")
                }
                .font(.body)
                .foregroundColor(.secondary)
                
                // Launch date
                Text("The update will go live on March 25, 2025. Make sure to check it out!")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
            
            // Learn More Button
            Button(action: {
                // Action when button is pressed (e.g., navigating to another page)
                if let url = URL(string: "http://www.yourvolunteerapp.com") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Learn More")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.top, 20)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
    }
}

struct AnnouncementView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()

        AnnouncementView() .environmentObject(authViewModel)
    }
}

