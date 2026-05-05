import SwiftUI
import SwiftData

struct PipelineView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Deal.stageOrder) private var deals: [Deal]
    @State private var showingDealForm = false
    @State private var selectedDeal: Deal?

    private let stages = ["Lead", "Qualified", "Proposal", "Negotiation", "Won", "Lost"]

    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(stages, id: \.self) { stage in
                        PipelineColumnView(
                            stageName: stage,
                            deals: deals.filter { $0.stageName == stage }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Pipeline")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingDealForm = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingDealForm) {
                DealFormView()
            }
            .sheet(item: $selectedDeal) { deal in
                DealDetailView(deal: deal)
            }
        }
    }
}
