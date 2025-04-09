import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isTrackingEnabled = false

    var body: some View {
        NavigationStack {
            VStack {
                Toggle("Tracking", isOn: $isTrackingEnabled)
                    .padding()
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    NavigationLink(destination: ProfileView()) {
                        DashboardButton(title: "Profile", icon: "person.fill")
                    }
                    NavigationLink(destination: SettingsView()) {
                        DashboardButton(title: "Settings", icon: "gearshape.fill")
                    }
                    NavigationLink(destination: Tracker()) {
                        DashboardButton(title: "Tracker", icon: "chart.bar.fill")
                    }
                    NavigationLink(destination: FowView()) {
                        DashboardButton(title: "Find Opportunities", icon: "magnifyingglass.circle.fill")
                    }
                    NavigationLink(destination: AnnouncementView()) {
                        DashboardButton(title: "Announcement", icon: "bubble.left.fill")
                    }
                    
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct DashboardButton: View {
    let title: String
    let icon: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
        }
        .frame(width: 140, height: 120)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

// Placeholder Views for Navigation
struct SettingView: View { var body: some View { Text("Settings Page").navigationTitle("Settings") } }
struct TrackerView: View { var body: some View { Text("Tracker Page").navigationTitle("Tracker") } }
struct FindOpportunitiesView: View { var body: some View { Text("Find Opportunities Page").navigationTitle("Find Opportunities") } }
struct AnnouncementsView: View { var body: some View { Text("Announcements Page").navigationTitle("Announcements") } }

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()

        DashboardView().environmentObject(authViewModel)
    }
}
