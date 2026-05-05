import SwiftUI
import SwiftData

struct ContactDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var contact: Contact
    @State private var showingDealForm = false

    private var sortedDeals: [Deal] {
        contact.deals.sorted { $0.updatedAt > $1.updatedAt }
    }

    private var sortedFollowUps: [FollowUp] {
        contact.followUps.sorted { $0.dueDate < $1.dueDate }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    contactHeader
                    contactInfo
                    dealsSection
                    followUpsSection
                }
                .padding()
            }
            .navigationTitle(contact.fullName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if !contact.phone.isEmpty {
                        Button(action: { callContact() }) {
                            Image(systemName: "phone")
                        }
                    }
                    if !contact.email.isEmpty {
                        Button(action: { emailContact() }) {
                            Image(systemName: "envelope")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingDealForm) {
                DealFormView()
            }
        }
    }

    private var contactHeader: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color.appPrimary.gradient)
                .frame(width: 64, height: 64)
                .overlay {
                    Text(contact.initials)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
            Text(contact.fullName)
                .font(.title2)
                .fontWeight(.bold)
            if !contact.company.isEmpty {
                Text("\(contact.jobTitle) at \(contact.company)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var contactInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !contact.email.isEmpty {
                HStack {
                    Image(systemName: "envelope")
                        .foregroundStyle(Color.appPrimary)
                    Text(contact.email)
                        .font(.subheadline)
                }
            }
            if !contact.phone.isEmpty {
                HStack {
                    Image(systemName: "phone")
                        .foregroundStyle(Color.appPrimary)
                    Text(contact.phone)
                        .font(.subheadline)
                }
            }
            if !contact.notes.isEmpty {
                Divider()
                Text(contact.notes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if !contact.tags.isEmpty {
                Divider()
                FlowLayout(spacing: 6) {
                    ForEach(contact.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.appPrimary.opacity(0.1))
                            .foregroundColor(Color.appPrimary)
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var dealsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Deals")
                    .font(.headline)
                Spacer()
                Button(action: { showingDealForm = true }) {
                    Image(systemName: "plus")
                        .font(.subheadline)
                }
            }

            if sortedDeals.isEmpty {
                Text("No deals yet")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(sortedDeals) { deal in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(deal.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(deal.stageName)
                                .font(.caption2)
                                .foregroundStyle(Color.stageColor(for: deal.stageName))
                        }
                        Spacer()
                        if deal.value > 0 {
                            Text(deal.value, format: .currency(code: "USD"))
                                .font(.caption)
                                .foregroundStyle(Color.appPrimary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var followUpsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Follow-ups")
                .font(.headline)

            if sortedFollowUps.isEmpty {
                Text("No follow-ups")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(sortedFollowUps) { followUp in
                    HStack {
                        Image(systemName: followUp.type.iconName)
                            .foregroundStyle(Color.appPrimary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(followUp.notes.isEmpty ? followUp.type.displayName : followUp.notes)
                                .font(.caption)
                            Text(followUp.dueDate.shortDateString)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if followUp.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.appSuccess)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private func callContact() {
        guard let url = URL(string: "tel://\(contact.phone)") else { return }
        UIApplication.shared.open(url)
    }

    private func emailContact() {
        guard let url = URL(string: "mailto:\(contact.email)") else { return }
        UIApplication.shared.open(url)
    }
}

extension Contact {
    var initials: String {
        let first = firstName.first.map(String.init) ?? ""
        let last = lastName.first.map(String.init) ?? ""
        return "\(first)\(last)".uppercased()
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}
