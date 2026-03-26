import SwiftUI

struct MasonryGridView: View {
    let notes: [StickyNote]
    let onToggleItem: (UUID, UUID) -> Void
    let onEdit: (StickyNote) -> Void
    let onArchive: (UUID) -> Void
    let onDelete: (UUID) -> Void

    var body: some View {
        GeometryReader { geo in
            let columnWidth = (geo.size.width - 40) / 2
            ScrollView {
                HStack(alignment: .top, spacing: 12) {
                    column(indices: leftIndices, width: columnWidth)
                    column(indices: rightIndices, width: columnWidth)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
        }
    }

    // Distribute notes into two columns by alternating
    private var leftIndices: [Int] {
        notes.indices.filter { $0 % 2 == 0 }
    }
    private var rightIndices: [Int] {
        notes.indices.filter { $0 % 2 != 0 }
    }

    @ViewBuilder
    private func column(indices: [Int], width: CGFloat) -> some View {
        LazyVStack(spacing: 12) {
            ForEach(indices, id: \.self) { i in
                let note = notes[i]
                NoteCardView(
                    note: note,
                    onToggleItem: { itemId in onToggleItem(note.id, itemId) },
                    onEdit: { onEdit(note) },
                    onArchive: { onArchive(note.id) },
                    onDelete: { onDelete(note.id) }
                )
                .frame(width: width)
            }
        }
    }
}
