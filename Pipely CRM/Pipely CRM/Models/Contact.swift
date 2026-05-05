import SwiftData
import Foundation

@Model
final class Contact {
    @Attribute(.unique) var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var company: String
    var jobTitle: String
    var tags: [String]
    var notes: String
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \Deal.contact)
    var deals: [Deal] = []

    @Relationship(deleteRule: .cascade)
    var followUps: [FollowUp] = []

    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }

    init(firstName: String, lastName: String, email: String = "",
         phone: String = "", company: String = "", jobTitle: String = "",
         tags: [String] = [], notes: String = "") {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.company = company
        self.jobTitle = jobTitle
        self.tags = tags
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
