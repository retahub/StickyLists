import Foundation

struct ChecklistItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var text: String
    var isChecked: Bool = false
}
