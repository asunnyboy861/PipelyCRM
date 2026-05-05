import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            PipelineView()
                .tabItem {
                    Label("Pipeline", systemImage: "chart.bar")
                }
                .tag(0)
            ContactsListView()
                .tabItem {
                    Label("Contacts", systemImage: "person.2")
                }
                .tag(1)
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }
                .tag(2)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Contact.self, Deal.self, Activity.self, FollowUp.self], inMemory: true)
}
