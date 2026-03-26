import Foundation

enum NoteCategory: String, CaseIterable, Codable, Identifiable {
    case personal = "Personal"
    case work = "Work"
    case shopping = "Shopping"
    case ideas = "Ideas"
    case health = "Health"
    case other = "Other"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var systemIcon: String {
        switch self {
        case .personal:  return "person.fill"
        case .work:      return "briefcase.fill"
        case .shopping:  return "cart.fill"
        case .ideas:     return "lightbulb.fill"
        case .health:    return "heart.fill"
        case .other:     return "star.fill"
        }
    }

    var accentColorName: String {
        switch self {
        case .personal:  return "lavender"
        case .work:      return "sky"
        case .shopping:  return "mint"
        case .ideas:     return "yellow"
        case .health:    return "pink"
        case .other:     return "peach"
        }
    }
}
