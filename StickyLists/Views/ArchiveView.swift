import SwiftUI

struct ArchiveView: View {
    @EnvironmentObject var vm: NotesViewModel
    @State private var noteToDelete: StickyNote? = nil
    @State private var showDeleteConfirm = false

    var body: some View {
        NavigationStack {
            Group {
                if vm.archivedNotes.isEmpty {
                    EmptyStateView(
                        systemImage: "archivebox",
                        title: "Archive is empty",
                        subtitle: "Completed lists you archive will appear here."
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(vm.archivedNotes) { note in
                                archivedCard(note)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Archive")
            .background(Color(.systemGray6))
        }
        .confirmationDialog("Delete this list?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                if let note = noteToDelete { vm.deleteNote(id: note.id) }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This cannot be undone.")
        }
    }

    @ViewBuilder
    private func archivedCard(_ note: StickyNote) -> some View {
        let accent = Color.pastelDark(named: note.colorName)

        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(note.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary.opacity(0.75))

                    HStack(spacing: 4) {
                        Image(systemName: note.category.systemIcon)
                            .font(.system(size: 9, weight: .semibold))
                        Text(note.category.displayName)
                            .font(.system(size: 10, weight: .semibold))
                    }
                    .foregroundColor(accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(accent.opacity(0.12), in: Capsule())
                }

                Spacer()

                // Archived badge
                Label("Archived", systemImage: "archivebox.fill")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(.systemGray5), in: Capsule())
            }
            .padding(12)

            if !note.checklist.isEmpty {
                Divider().padding(.horizontal, 12)
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(note.checklist.prefix(3)) { item in
                        ChecklistItemRow(item: item, onToggle: nil)
                    }
                    if note.checklist.count > 3 {
                        Text("+\(note.checklist.count - 3) more")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .padding(.leading, 24)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }

            Divider().padding(.horizontal, 12)

            HStack(spacing: 0) {
                Button(action: { vm.restoreNote(id: note.id) }) {
                    Label("Restore", systemImage: "arrow.uturn.backward")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.pastelBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.plain)

                Divider().frame(height: 32)

                Button(action: {
                    noteToDelete = note
                    showDeleteConfirm = true
                }) {
                    Label("Delete", systemImage: "trash")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
            }
        }
        .background(
            Color.pastel(named: note.colorName).opacity(0.5),
            in: RoundedRectangle(cornerRadius: 16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(accent.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: accent.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
