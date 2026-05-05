import SwiftUI

extension Color {
    static let appPrimary = Color(red: 0.149, green: 0.388, blue: 0.922)
    static let appSecondary = Color(red: 0.486, green: 0.227, blue: 0.929)
    static let appSuccess = Color(red: 0.086, green: 0.639, blue: 0.290)
    static let appWarning = Color(red: 0.851, green: 0.467, blue: 0.024)
    static let appDanger = Color(red: 0.863, green: 0.149, blue: 0.149)
    static let appSurface = Color(red: 0.973, green: 0.980, blue: 0.988)
    static let appTextSecondary = Color(red: 0.392, green: 0.455, blue: 0.518)

    static let stageLead = Color(red: 0.580, green: 0.639, blue: 0.722)
    static let stageQualified = Color(red: 0.376, green: 0.647, blue: 0.980)
    static let stageProposal = Color(red: 0.984, green: 0.749, blue: 0.141)
    static let stageNegotiation = Color(red: 0.984, green: 0.573, blue: 0.235)
    static let stageWon = Color(red: 0.204, green: 0.827, blue: 0.600)
    static let stageLost = Color(red: 0.973, green: 0.443, blue: 0.443)

    static func stageColor(for name: String) -> Color {
        switch name {
        case "Lead": return .stageLead
        case "Qualified": return .stageQualified
        case "Proposal": return .stageProposal
        case "Negotiation": return .stageNegotiation
        case "Won": return .stageWon
        case "Lost": return .stageLost
        default: return .stageLead
        }
    }
}
