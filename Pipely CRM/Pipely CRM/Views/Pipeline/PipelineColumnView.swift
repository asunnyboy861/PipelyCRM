import SwiftUI
import SwiftData

struct PipelineColumnView: View {
    let stageName: String
    let deals: [Deal]

    private var totalValue: Decimal {
        deals.reduce(0) { $0 + $1.value }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(Color.stageColor(for: stageName))
                    .frame(width: 10, height: 10)
                Text(stageName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(deals.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if totalValue > 0 {
                Text(totalValue, format: .currency(code: "USD"))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Divider()

            LazyVStack(spacing: 8) {
                ForEach(deals) { deal in
                    DealCardView(deal: deal)
                }
            }

            Spacer(minLength: 0)
        }
        .frame(width: 260)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
