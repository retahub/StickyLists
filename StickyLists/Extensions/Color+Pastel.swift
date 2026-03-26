import SwiftUI

extension Color {
    static let pastelColors: [String: Color] = [
        "yellow":   Color(red: 1.00, green: 0.96, blue: 0.72),
        "pink":     Color(red: 1.00, green: 0.84, blue: 0.87),
        "mint":     Color(red: 0.80, green: 0.96, blue: 0.88),
        "lavender": Color(red: 0.88, green: 0.84, blue: 0.98),
        "peach":    Color(red: 1.00, green: 0.89, blue: 0.78),
        "sky":      Color(red: 0.78, green: 0.91, blue: 1.00),
    ]

    static let pastelColorOrder: [String] = ["yellow", "pink", "mint", "lavender", "peach", "sky"]

    static func pastel(named name: String) -> Color {
        pastelColors[name] ?? pastelColors["yellow"]!
    }

    static var defaultPastelName: String { "yellow" }

    // Slightly darker versions for text/borders
    static func pastelDark(named name: String) -> Color {
        switch name {
        case "yellow":   return Color(red: 0.85, green: 0.78, blue: 0.30)
        case "pink":     return Color(red: 0.88, green: 0.55, blue: 0.62)
        case "mint":     return Color(red: 0.35, green: 0.78, blue: 0.58)
        case "lavender": return Color(red: 0.60, green: 0.50, blue: 0.85)
        case "peach":    return Color(red: 0.90, green: 0.60, blue: 0.35)
        case "sky":      return Color(red: 0.35, green: 0.65, blue: 0.90)
        default:         return .gray
        }
    }
    
    // Pastel blue accent color
    static let pastelBlue = Color(red: 0.68, green: 0.85, blue: 1.0)
}
