import SwiftUI

struct NoteCardView: View {
    let note: StickyNote
    let onToggleItem: (UUID) -> Void
    let onEdit: () -> Void
    let onArchive: () -> Void
    let onDelete: () -> Void

    private var bgColor: Color { .pastel(named: note.colorName) }
    private var accentColor: Color { .pastelDark(named: note.colorName) }
    private var previewItems: [ChecklistItem] { Array(note.checklist.prefix(4)) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(note.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary.opacity(0.85))
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Three-dot menu
                    Menu {
                        Button("Edit", systemImage: "pencil", action: onEdit)
                        Divider()
                        if note.allItemsChecked {
                            Button("Archive", systemImage: "archivebox", action: onArchive)
                        }
                        Button("Delete", systemImage: "trash", role: .destructive, action: onDelete)
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(accentColor)
                            .padding(6)
                            .background(accentColor.opacity(0.12), in: Circle())
                    }
                }

                // Category badge
                HStack(spacing: 4) {
                    Image(systemName: note.category.systemIcon)
                        .font(.system(size: 9, weight: .semibold))
                    Text(note.category.displayName)
                        .font(.system(size: 10, weight: .semibold))
                }
                .foregroundColor(accentColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(accentColor.opacity(0.15), in: Capsule())
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
            .padding(.bottom, 8)

            // Checklist preview
            if !note.checklist.isEmpty {
                Divider()
                    .background(accentColor.opacity(0.25))
                    .padding(.horizontal, 12)

                VStack(alignment: .leading, spacing: 5) {
                    ForEach(previewItems) { item in
                        ChecklistItemRow(item: item) {
                            onToggleItem(item.id)
                        }
                    }

                    if note.checklist.count > 4 {
                        Text("+\(note.checklist.count - 4) more")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .padding(.leading, 24)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(accentColor.opacity(0.15))
                            .frame(height: 4)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(accentColor.opacity(0.7))
                            .frame(width: geo.size.width * note.completionProgress, height: 4)
                            .animation(.spring(response: 0.4), value: note.completionProgress)
                    }
                }
                .frame(height: 4)
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
            }

            // All done banner
            if note.allItemsChecked {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 12))
                    Text("All done!")
                        .font(.system(size: 12, weight: .semibold))
                    Spacer()
                    Button(action: onArchive) {
                        Text("Archive")
                            .font(.system(size: 11, weight: .semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.white.opacity(0.5), in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .foregroundColor(accentColor)
                .padding(.horizontal, 12)
                .padding(.bottom, 10)
                .padding(.top, 2)
            }
        }
        .background(bgColor, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(accentColor.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: accentColor.opacity(0.15), radius: 6, x: 0, y: 3)
    }
}
