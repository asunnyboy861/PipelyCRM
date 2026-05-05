import SwiftUI
import SwiftData

struct ContactFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var company: String = ""
    @State private var jobTitle: String = ""
    @State private var notes: String = ""
    @State private var tagText: String = ""
    @State private var tags: [String] = []

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }

                Section("Contact Info") {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                }

                Section("Company") {
                    TextField("Company", text: $company)
                    TextField("Job Title", text: $jobTitle)
                }

                Section("Tags") {
                    FlowLayout(spacing: 6) {
                        ForEach(tags, id: \.self) { tag in
                            HStack(spacing: 4) {
                                Text(tag)
                                    .font(.caption)
                                Button(action: { tags.removeAll { $0 == tag } }) {
                                    Image(systemName: "xmark")
                                        .font(.caption2)
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.appPrimary.opacity(0.1))
                            .foregroundColor(Color.appPrimary)
                            .cornerRadius(4)
                        }
                    }
                    HStack {
                        TextField("Add tag", text: $tagText)
                            .onSubmit {
                                addTag()
                            }
                        Button("Add", action: addTag)
                            .disabled(tagText.isEmpty)
                    }
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveContact()
                        dismiss()
                    }
                    .disabled(firstName.isEmpty && lastName.isEmpty)
                }
            }
        }
    }

    private func addTag() {
        let trimmed = tagText.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty && !tags.contains(trimmed) {
            tags.append(trimmed)
        }
        tagText = ""
    }

    private func saveContact() {
        let contact = Contact(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            company: company,
            jobTitle: jobTitle,
            tags: tags,
            notes: notes
        )
        modelContext.insert(contact)
    }
}
