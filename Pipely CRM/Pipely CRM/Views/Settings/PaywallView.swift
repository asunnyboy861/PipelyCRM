import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    let purchaseManager: PurchaseManager
    @State private var selectedPlan: PlanType = .yearly
    @State private var isPurchasing = false

    enum PlanType {
        case monthly, yearly
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    featuresList
                    planSelector
                    subscribeButton
                    restoreButton
                    termsText
                }
                .padding()
            }
            .navigationTitle("Pipely Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "crown.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.appWarning)

            Text("Unlock Pipely Pro")
                .font(.title2)
                .fontWeight(.bold)

            Text("Unlimited contacts, deals, and team collaboration")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var featuresList: some View {
        VStack(alignment: .leading, spacing: 12) {
            featureRow(icon: "person.2", text: "Unlimited contacts")
            featureRow(icon: "chart.bar", text: "Unlimited deals & pipelines")
            featureRow(icon: "bell", text: "Unlimited follow-up reminders")
            featureRow(icon: "person.3", text: "Up to 5 team members")
            featureRow(icon: "square.and.arrow.up", text: "CSV data export")
            featureRow(icon: "chart.pie", text: "Advanced reports")
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.appPrimary)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
        }
    }

    private var planSelector: some View {
        HStack(spacing: 12) {
            planCard(.monthly)
            planCard(.yearly)
        }
    }

    private func planCard(_ plan: PlanType) -> some View {
        let isSelected = selectedPlan == plan
        return Button(action: { selectedPlan = plan }) {
            VStack(spacing: 8) {
                if plan == .yearly {
                    Text("BEST VALUE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.appSuccess)
                        .cornerRadius(4)
                }

                Text(plan == .monthly ? "Monthly" : "Yearly")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(plan == .monthly ? "$9.99" : "$79.99")
                    .font(.title3)
                    .fontWeight(.bold)

                if plan == .yearly {
                    Text("$6.67/mo")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? Color.appPrimary.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.appPrimary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var subscribeButton: some View {
        Button(action: purchase) {
            HStack {
                if isPurchasing {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(selectedPlan == .monthly ? "Subscribe $9.99/month" : "Subscribe $79.99/year")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.appPrimary)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(isPurchasing)
    }

    private var restoreButton: some View {
        Button("Restore Purchases") {
            Task {
                await purchaseManager.restorePurchases()
                if purchaseManager.isPro {
                    dismiss()
                }
            }
        }
        .font(.subheadline)
        .foregroundStyle(Color.appPrimary)
    }

    private var termsText: some View {
        VStack(spacing: 4) {
            Text("Free trial for 7 days, then auto-renews.")
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text("Cancel anytime in Settings > Subscriptions.")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private func purchase() {
        guard let product = selectedPlan == .monthly ? purchaseManager.monthlyProduct : purchaseManager.yearlyProduct else { return }
        isPurchasing = true
        Task {
            _ = await purchaseManager.purchase(product)
            isPurchasing = false
            if purchaseManager.isPro {
                dismiss()
            }
        }
    }
}
