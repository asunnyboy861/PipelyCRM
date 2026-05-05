import SwiftUI
import SwiftData

@main
struct Pipely_CRMApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Contact.self, Deal.self, Activity.self, FollowUp.self])
    }
}
