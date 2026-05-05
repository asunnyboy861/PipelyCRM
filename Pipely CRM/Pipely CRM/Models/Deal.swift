import SwiftData
import Foundation

@Model
final class Deal {
    @Attribute(.unique) var id: UUID
    var title: String
    var value: Decimal
    var stageName: String
    var stageOrder: Int
    var expectedCloseDate: Date?
    var probability: Int
    var notes: String
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \Activity.deal)
    var activities: [Activity] = []

    var contact: Contact?

    init(title: String, value: Decimal = 0, stageName: String = "Lead",
         stageOrder: Int = 0, expectedCloseDate: Date? = nil,
         probability: Int = 0, notes: String = "", contact: Contact? = nil) {
        self.id = UUID()
        self.title = title
        self.value = value
        self.stageName = stageName
        self.stageOrder = stageOrder
        self.expectedCloseDate = expectedCloseDate
        self.probability = probability
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
        self.contact = contact
    }
}
