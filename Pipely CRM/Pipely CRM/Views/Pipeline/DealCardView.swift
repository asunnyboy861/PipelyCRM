import SwiftUI

struct DealCardView: View {
    let deal: Deal

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(deal.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)

            if deal.value > 0 {
                Text(deal.value, format: .currency(code: "USD"))
                    .font(.caption)
                    .foregroundStyle(Color.appPrimary)
                    .fontWeight(.semibold)
            }

            if let contact = deal.contact {
                HStack(spacing: 4) {
                    Image(systemName: "person")
                        .font(.caption2)
                    Text(contact.fullName)
                        .font(.caption2)
                        .lineLimit(1)
                }
                .foregroundStyle(.secondary)
            }

            if let closeDate = deal.expectedCloseDate {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text(closeDate.shortDateString)
                        .font(.caption2)
                }
                .foregroundStyle(.secondary)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}
