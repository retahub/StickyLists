import Foundation

struct StickyNote: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var checklist: [ChecklistItem]
    var category: NoteCategory
    var colorName: String
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var isArchived: Bool = false

    var allItemsChecked: Bool {
        !checklist.isEmpty && checklist.allSatisfy { $0.isChecked }
    }

    var completionProgress: Double {
        guard !checklist.isEmpty else { return 0 }
        let checked = checklist.filter { $0.isChecked }.count
        return Double(checked) / Double(checklist.count)
    }

    var completionText: String {
        let checked = checklist.filter { $0.isChecked }.count
        return "\(checked)/\(checklist.count)"
    }
}
