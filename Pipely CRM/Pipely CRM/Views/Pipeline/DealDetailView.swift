import SwiftUI
import SwiftData

struct DealDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var deal: Deal
    @State private var showingActivityForm = false
    @State private var showingFollowUpForm = false

    private var sortedActivities: [Activity] {
        deal.activities.sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    dealHeader
                    contactSection
                    activitiesSection
                    quickActions
                }
                .padding()
            }
            .navigationTitle("Deal Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        stageMenuItems
                    } label: {
                        Image(systemName: "arrow.triangle.branch")
                    }
                }
            }
            .sheet(isPresented: $showingActivityForm) {
                ActivityFormView(deal: deal)
            }
        }
    }

    private var dealHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(deal.title)
                .font(.title2)
                .fontWeight(.bold)

            HStack {
                if deal.value > 0 {
                    Text(deal.value, format: .currency(code: "USD"))
                        .font(.title3)
                        .foregroundStyle(Color.appPrimary)
                        .fontWeight(.semibold)
                }

                Spacer()

                Text(deal.stageName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.stageColor(for: deal.stageName).opacity(0.2))
                    .foregroundColor(Color.stageColor(for: deal.stageName))
                    .cornerRadius(6)
            }

            if let closeDate = deal.expectedCloseDate {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                    Text("Expected close: \(closeDate.shortDateString)")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var contactSection: some View {
        Group {
            if let contact = deal.contact {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contact")
                        .font(.headline)
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(contact.fullName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            if !contact.company.isEmpty {
                                Text("\(contact.jobTitle) · \(contact.company)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        if !contact.phone.isEmpty {
                            Button(action: { callContact(contact) }) {
                                Image(systemName: "phone")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.appPrimary)
                            }
                        }
                        if !contact.email.isEmpty {
                            Button(action: { emailContact(contact) }) {
                                Image(systemName: "envelope")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.appPrimary)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }

    private var activitiesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Activity")
                    .font(.headline)
                Spacer()
                Button(action: { showingActivityForm = true }) {
                    Image(systemName: "plus")
                        .font(.subheadline)
                }
            }

            if sortedActivities.isEmpty {
                Text("No activities yet")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(sortedActivities) { activity in
                    HStack(spacing: 8) {
                        Image(systemName: activity.type.iconName)
                            .font(.caption)
                            .foregroundStyle(Color.appPrimary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(activity.title)
                                .font(.caption)
                                .fontWeight(.medium)
                            Text(activity.date.shortDateString)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var quickActions: some View {
        HStack(spacing: 16) {
            if let contact = deal.contact, !contact.phone.isEmpty {
                quickActionButton(icon: "phone", title: "Call") { callContact(contact) }
            }
            if let contact = deal.contact, !contact.email.isEmpty {
                quickActionButton(icon: "envelope", title: "Email") { emailContact(contact) }
            }
            quickActionButton(icon: "note.text", title: "Note") { showingActivityForm = true }
        }
    }

    private func quickActionButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.caption)
            }
            .foregroundStyle(Color.appPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.appPrimary.opacity(0.1))
            .cornerRadius(10)
        }
    }

    @ViewBuilder
    private var stageMenuItems: some View {
        let stages = ["Lead", "Qualified", "Proposal", "Negotiation", "Won", "Lost"]
        ForEach(stages, id: \.self) { stage in
            Button(action: { moveDeal(to: stage) }) {
                Label(stage, systemImage: "circle.fill")
            }
        }
    }

    private func moveDeal(to stage: String) {
        let stages = ["Lead", "Qualified", "Proposal", "Negotiation", "Won", "Lost"]
        deal.stageName = stage
        deal.stageOrder = stages.firstIndex(of: stage) ?? 0
        deal.updatedAt = Date()
    }

    private func callContact(_ contact: Contact) {
        guard let url = URL(string: "tel://\(contact.phone)") else { return }
        UIApplication.shared.open(url)
    }

    private func emailContact(_ contact: Contact) {
        guard let url = URL(string: "mailto:\(contact.email)") else { return }
        UIApplication.shared.open(url)
    }
}

struct ActivityFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let deal: Deal

    @State private var type: ActivityType = .note
    @State private var title: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Picker("Type", selection: $type) {
                    ForEach(ActivityType.allCases, id: \.self) { t in
                        Text(t.displayName).tag(t)
                    }
                }
                TextField("Title", text: $title)
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(3...6)
            }
            .navigationTitle("Add Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveActivity()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }

    private func saveActivity() {
        let activity = Activity(type: type, title: title, notes: notes, deal: deal)
        modelContext.insert(activity)
    }
}
