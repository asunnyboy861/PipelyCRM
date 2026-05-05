import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<FollowUp> { !$0.isCompleted },
           sort: \FollowUp.dueDate) private var followUps: [FollowUp]
    @State private var showingFollowUpForm = false

    private var overdue: [FollowUp] {
        followUps.filter { $0.dueDate.isOverdue }
    }

    private var today: [FollowUp] {
        followUps.filter { $0.dueDate.isToday }
    }

    private var upcoming: [FollowUp] {
        followUps.filter { $0.dueDate.isFuture || $0.dueDate.isTomorrow }
    }

    @Query(filter: #Predicate<FollowUp> { $0.isCompleted },
           sort: \FollowUp.dueDate, order: .reverse) private var completed: [FollowUp]

    var body: some View {
        NavigationStack {
            List {
                if !overdue.isEmpty {
                    Section {
                        ForEach(overdue) { followUp in
                            FollowUpRowView(followUp: followUp, style: .overdue)
                        }
                    } header: {
                        Label("Overdue", systemImage: "exclamationmark.circle")
                            .foregroundStyle(Color.appDanger)
                    }
                }

                if !today.isEmpty {
                    Section {
                        ForEach(today) { followUp in
                            FollowUpRowView(followUp: followUp, style: .today)
                        }
                    } header: {
                        Label("Today", systemImage: "calendar")
                            .foregroundStyle(Color.appWarning)
                    }
                }

                if !upcoming.isEmpty {
                    Section {
                        ForEach(upcoming) { followUp in
                            FollowUpRowView(followUp: followUp, style: .upcoming)
                        }
                    } header: {
                        Label("Upcoming", systemImage: "clock")
                            .foregroundStyle(Color.appSuccess)
                    }
                }

                if !completed.isEmpty {
                    Section {
                        ForEach(completed.prefix(5)) { followUp in
                            FollowUpRowView(followUp: followUp, style: .completed)
                        }
                    } header: {
                        Text("Completed (\(completed.count))")
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingFollowUpForm = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingFollowUpForm) {
                FollowUpFormView()
            }
            .overlay {
                if followUps.isEmpty && completed.isEmpty {
                    EmptyStateView(
                        icon: "checkmark.circle",
                        title: "All Caught Up",
                        subtitle: "No follow-ups scheduled. Add one to stay on track."
                    )
                }
            }
        }
    }
}

enum FollowUpStyle {
    case overdue, today, upcoming, completed
}

struct FollowUpRowView: View {
    @Environment(\.modelContext) private var modelContext
    let followUp: FollowUp
    let style: FollowUpStyle

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: followUp.type.iconName)
                .font(.title3)
                .foregroundStyle(iconColor)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(followUp.notes.isEmpty ? followUp.type.displayName : followUp.notes)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .strikethrough(style == .completed)

                if let contact = followUp.contact {
                    Text(contact.fullName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(followUp.dueDate.relativeString)
                    .font(.caption2)
                    .foregroundStyle(dateColor)
            }

            Spacer()

            if style != .completed {
                Button(action: { completeFollowUp() }) {
                    Image(systemName: "checkmark.circle")
                        .font(.title3)
                        .foregroundStyle(Color.appSuccess)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private var iconColor: Color {
        switch style {
        case .overdue: return .appDanger
        case .today: return .appWarning
        case .upcoming: return .appSuccess
        case .completed: return .secondary
        }
    }

    private var dateColor: Color {
        switch style {
        case .overdue: return .appDanger
        case .today: return .appWarning
        case .upcoming: return .secondary
        case .completed: return .secondary
        }
    }

    private func completeFollowUp() {
        followUp.isCompleted = true
        NotificationService.shared.cancelReminder(id: followUp.id)
    }
}

struct FollowUpFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var contacts: [Contact]

    @State private var type: FollowUpType = .call
    @State private var notes: String = ""
    @State private var dueDate: Date = Date()
    @State private var selectedContact: Contact?
    @State private var hasReminder = true

    var body: some View {
        NavigationStack {
            Form {
                Picker("Type", selection: $type) {
                    ForEach(FollowUpType.allCases, id: \.self) { t in
                        Text(t.displayName).tag(t)
                    }
                }

                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(2...4)

                DatePicker("Due Date", selection: $dueDate, in: Date.now..., displayedComponents: [.date, .hourAndMinute])

                Picker("Contact", selection: $selectedContact) {
                    Text("None").tag(nil as Contact?)
                    ForEach(contacts) { contact in
                        Text(contact.fullName).tag(contact as Contact?)
                    }
                }

                Toggle("Set Reminder", isOn: $hasReminder)
            }
            .navigationTitle("New Follow-up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveFollowUp()
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveFollowUp() {
        let followUp = FollowUp(
            type: type,
            notes: notes,
            dueDate: dueDate,
            contact: selectedContact
        )
        modelContext.insert(followUp)

        if hasReminder {
            Task {
                await NotificationService.shared.scheduleFollowUpReminder(
                    id: followUp.id,
                    title: notes.isEmpty ? type.displayName : notes,
                    dueDate: dueDate
                )
            }
        }
    }
}
