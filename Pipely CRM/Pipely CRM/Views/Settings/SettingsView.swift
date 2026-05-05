import SwiftUI
import SwiftData

struct SettingsView: View {
    @State private var purchaseManager = PurchaseManager()
    @State private var showingPaywall = false
    @State private var showingSupport = false

    var body: some View {
        NavigationStack {
            List {
                proSection
                generalSection
                supportSection
                legalSection
                aboutSection
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingPaywall) {
                PaywallView(purchaseManager: purchaseManager)
            }
            .sheet(isPresented: $showingSupport) {
                ContactSupportView()
            }
        }
    }

    private var proSection: some View {
        Section {
            if purchaseManager.isPro {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(Color.appWarning)
                    Text("Pipely Pro")
                        .fontWeight(.medium)
                    Spacer()
                    Text("Active")
                        .font(.caption)
                        .foregroundStyle(Color.appSuccess)
                }
            } else {
                Button(action: { showingPaywall = true }) {
                    HStack {
                        Image(systemName: "crown")
                            .foregroundStyle(Color.appWarning)
                        Text("Upgrade to Pro")
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var generalSection: some View {
        Section("General") {
            NavigationLink {
                Text("Notification settings coming soon")
            } label: {
                Label("Notifications", systemImage: "bell")
            }
        }
    }

    private var supportSection: some View {
        Section("Support") {
            Button(action: { showingSupport = true }) {
                Label("Contact Support", systemImage: "envelope")
            }
            if !purchaseManager.isPro {
                Button(action: { showingPaywall = true }) {
                    Label("Restore Purchases", systemImage: "arrow.uturn.down")
                }
            }
        }
    }

    private var legalSection: some View {
        Section("Legal") {
            Link(destination: URL(string: "https://asunnyboy861.github.io/PipelyCRM/support.html")!) {
                Label("Support Page", systemImage: "questionmark.circle")
            }
            Link(destination: URL(string: "https://asunnyboy861.github.io/PipelyCRM/privacy.html")!) {
                Label("Privacy Policy", systemImage: "hand.raised")
            }
            Link(destination: URL(string: "https://asunnyboy861.github.io/PipelyCRM/terms.html")!) {
                Label("Terms of Use", systemImage: "doc.text")
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
