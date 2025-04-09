import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var selectedTheme = "Light"
    @State private var twoFactorAuthenticationEnabled = false
    @State private var syncDataEnabled = true
    @State private var enableDebugMode = false
    @AppStorage("userName") private var userName = "John Doe"

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Profile")) {
                    Text("Name: \(userName)")
                }

                Section(header: Text("General")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Enable Notifications")
                    }
                    Toggle(isOn: $darkModeEnabled) {
                        Text("Dark Mode")
                    }
                    Picker("Theme", selection: $selectedTheme) {
                        Text("Light").tag("Light")
                        Text("Dark").tag("Dark")
                    }
                }

                Section(header: Text("Security")) {
                    Toggle(isOn: $twoFactorAuthenticationEnabled) {
                        Text("Enable Two-Factor Authentication")
                    }
                }

                Section(header: Text("Data & Syncing")) {
                    Toggle(isOn: $syncDataEnabled) {
                        Text("Enable Cloud Sync")
                    }
                }

                Section(header: Text("Advanced")) {
                    Toggle(isOn: $enableDebugMode) {
                        Text("Enable Debug Mode")
                    }
                }

                Section(header: Text("About")) {
                    Text("App Version 1.0.0")
                }

                Section(header: Text("Support")) {
                    Button("Contact Support") {
                        // Action to open support
                    }
                    Button("Send Feedback") {
                        // Action to send feedback
                    }
                    Button("Rate the App") {
                        // Action to open the App Store
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()
        SettingsView().environmentObject(authViewModel)
    }
}
