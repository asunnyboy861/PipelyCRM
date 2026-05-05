import SwiftUI
import SwiftData

struct ContactsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Contact.updatedAt, order: .reverse) private var contacts: [Contact]
    @State private var searchText = ""
    @State private var showingForm = false
    @State private var selectedContact: Contact?

    private var filteredContacts: [Contact] {
        if searchText.isEmpty { return contacts }
        return contacts.filter {
            $0.fullName.localizedCaseInsensitiveContains(searchText) ||
            $0.company.localizedCaseInsensitiveContains(searchText) ||
            $0.email.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                SearchBar(text: $searchText, placeholder: "Search contacts...")
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

                ForEach(filteredContacts) { contact in
                    Button(action: { selectedContact = contact }) {
                        contactRow(contact)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingForm = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingForm) {
                ContactFormView()
            }
            .sheet(item: $selectedContact) { contact in
                ContactDetailView(contact: contact)
            }
            .overlay {
                if contacts.isEmpty {
                    EmptyStateView(
                        icon: "person.2",
                        title: "No Contacts",
                        subtitle: "Add your first contact to get started",
                        actionTitle: "Add Contact",
                        action: { showingForm = true }
                    )
                }
            }
        }
    }

    private func contactRow(_ contact: Contact) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(contact.fullName)
                .font(.subheadline)
                .fontWeight(.medium)
            if !contact.company.isEmpty {
                Text("\(contact.jobTitle) · \(contact.company)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            let dealCount = contact.deals.count
            if dealCount > 0 {
                let totalValue = contact.deals.reduce(Decimal(0)) { $0 + $1.value }
                Text("\(dealCount) deal\(dealCount == 1 ? "" : "s") · \(totalValue, format: .currency(code: "USD"))")
                    .font(.caption2)
                    .foregroundStyle(Color.appPrimary)
            }
        }
        .padding(.vertical, 4)
    }
}
