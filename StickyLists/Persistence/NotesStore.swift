import Foundation

struct NotesStore {
    private static let key = "sticky_notes_v1"

    static func save(_ notes: [StickyNote]) {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func load() -> [StickyNote] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let notes = try? JSONDecoder().decode([StickyNote].self, from: data)
        else { return [] }
        return notes
    }
}
