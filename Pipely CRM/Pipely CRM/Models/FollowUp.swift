import SwiftData
import Foundation

@Model
final class FollowUp {
    @Attribute(.unique) var id: UUID
    var typeRaw: String
    var notes: String
    var dueDate: Date
    var isCompleted: Bool
    var reminderDate: Date?
    var createdAt: Date

    var contact: Contact?
    var deal: Deal?

    var type: FollowUpType {
        get { FollowUpType(rawValue: typeRaw) ?? .call }
        set { typeRaw = newValue.rawValue }
    }

    init(type: FollowUpType = .call, notes: String = "", dueDate: Date = Date(),
         isCompleted: Bool = false, reminderDate: Date? = nil,
         contact: Contact? = nil, deal: Deal? = nil) {
        self.id = UUID()
        self.typeRaw = type.rawValue
        self.notes = notes
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.reminderDate = reminderDate
        self.createdAt = Date()
        self.contact = contact
        self.deal = deal
    }
}

enum FollowUpType: String, Codable, CaseIterable {
    case call = "call"
    case email = "email"
    case meeting = "meeting"

    var iconName: String {
        switch self {
        case .call: return "phone"
        case .email: return "envelope"
        case .meeting: return "calendar"
        }
    }

    var displayName: String {
        switch self {
        case .call: return "Call"
        case .email: return "Email"
        case .meeting: return "Meeting"
        }
    }
}
