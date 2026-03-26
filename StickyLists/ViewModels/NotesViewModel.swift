import Foundation
import Combine

class NotesViewModel: ObservableObject {
    @Published var notes: [StickyNote] = []
    @Published var selectedCategory: NoteCategory? = nil

    init() {
        notes = NotesStore.load()
    }

    // MARK: - Filtered Views

    func activeNotes(for category: NoteCategory? = nil) -> [StickyNote] {
        let active = notes.filter { !$0.isArchived }
        guard let category else { return active }
        return active.filter { $0.category == category }
    }

    var archivedNotes: [StickyNote] {
        notes.filter { $0.isArchived }
    }

    // MARK: - CRUD

    func addNote(_ note: StickyNote) {
        notes.insert(note, at: 0)
        persist()
    }

    func updateNote(_ updated: StickyNote) {
        guard let idx = notes.firstIndex(where: { $0.id == updated.id }) else { return }
        var note = updated
        note.updatedAt = Date()
        notes[idx] = note
        persist()
    }

    func deleteNote(id: UUID) {
        notes.removeAll { $0.id == id }
        persist()
    }

    func archiveNote(id: UUID) {
        guard let idx = notes.firstIndex(where: { $0.id == id }) else { return }
        notes[idx].isArchived = true
        persist()
    }

    func restoreNote(id: UUID) {
        guard let idx = notes.firstIndex(where: { $0.id == id }) else { return }
        notes[idx].isArchived = false
        persist()
    }

    func toggleChecklistItem(noteId: UUID, itemId: UUID) {
        guard let noteIdx = notes.firstIndex(where: { $0.id == noteId }),
              let itemIdx = notes[noteIdx].checklist.firstIndex(where: { $0.id == itemId })
        else { return }
        notes[noteIdx].checklist[itemIdx].isChecked.toggle()
        notes[noteIdx].updatedAt = Date()
        persist()
    }

    // MARK: - Persistence

    private func persist() {
        NotesStore.save(notes)
    }
}
