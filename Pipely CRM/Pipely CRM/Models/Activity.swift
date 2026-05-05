import SwiftData
import Foundation

@Model
final class Activity {
    @Attribute(.unique) var id: UUID
    var typeRaw: String
    var title: String
    var notes: String
    var date: Date
    var isCompleted: Bool

    var deal: Deal?

    var type: ActivityType {
        get { ActivityType(rawValue: typeRaw) ?? .note }
        set { typeRaw = newValue.rawValue }
    }

    init(type: ActivityType = .note, title: String, notes: String = "",
         date: Date = Date(), isCompleted: Bool = false, deal: Deal? = nil) {
        self.id = UUID()
        self.typeRaw = type.rawValue
        self.title = title
        self.notes = notes
        self.date = date
        self.isCompleted = isCompleted
        self.deal = deal
    }
}

enum ActivityType: String, Codable, CaseIterable {
    case call = "call"
    case email = "email"
    case meeting = "meeting"
    case note = "note"
    case task = "task"

    var iconName: String {
        switch self {
        case .call: return "phone"
        case .email: return "envelope"
        case .meeting: return "calendar"
        case .note: return "note.text"
        case .task: return "checkmark.circle"
        }
    }

    var displayName: String {
        switch self {
        case .call: return "Call"
        case .email: return "Email"
        case .meeting: return "Meeting"
        case .note: return "Note"
        case .task: return "Task"
        }
    }
}
