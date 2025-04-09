import SwiftUI
import SwiftData

@main
struct deemoApp: App {
    @StateObject var authViewModel = AuthViewModel()  // Create a shared AuthViewModel
    
    // Optional: Use ModelContainer if you're using SwiftData for persistence
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self, // Define all your data models here
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ProfileView()
                .environmentObject(authViewModel)
        }
    }
}
