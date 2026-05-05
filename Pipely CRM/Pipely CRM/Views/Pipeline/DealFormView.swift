import SwiftUI
import SwiftData

struct DealFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var contacts: [Contact]

    @State private var title: String = ""
    @State private var value: String = ""
    @State private var stageName: String = "Lead"
    @State private var expectedCloseDate: Date = Date().addingTimeInterval(30 * 86400)
    @State private var probability: Int = 0
    @State private var notes: String = ""
    @State private var selectedContact: Contact?

    private let stages = ["Lead", "Qualified", "Proposal", "Negotiation", "Won", "Lost"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Deal Info") {
                    TextField("Title", text: $title)
                    TextField("Value ($)", text: $value)
                        .keyboardType(.decimalPad)
                    Picker("Stage", selection: $stageName) {
                        ForEach(stages, id: \.self) { Text($0) }
                    }
                    DatePicker("Expected Close", selection: $expectedCloseDate, displayedComponents: .date)
                }

                Section("Contact") {
                    Picker("Contact", selection: $selectedContact) {
                        Text("None").tag(nil as Contact?)
                        ForEach(contacts) { contact in
                            Text(contact.fullName).tag(contact as Contact?)
                        }
                    }
                }

                Section("Details") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Deal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveDeal()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }

    private func saveDeal() {
        let dealValue = Decimal(string: value) ?? 0
        let stageOrder = stages.firstIndex(of: stageName) ?? 0
        let deal = Deal(
            title: title,
            value: dealValue,
            stageName: stageName,
            stageOrder: stageOrder,
            expectedCloseDate: expectedCloseDate,
            probability: probability,
            notes: notes,
            contact: selectedContact
        )
        modelContext.insert(deal)
    }
}
