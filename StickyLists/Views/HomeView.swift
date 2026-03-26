import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: NotesViewModel
    @State private var showingAddNote = false
    @State private var noteToEdit: StickyNote? = nil
    @State private var noteToDelete: StickyNote? = nil
    @State private var showDeleteConfirm = false

    private var displayedNotes: [StickyNote] {
        vm.activeNotes(for: vm.selectedCategory)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 0) {
                    CategoryFilterBar(selectedCategory: $vm.selectedCategory)
                        .padding(.top, 4)

                    if displayedNotes.isEmpty {
                        EmptyStateView(
                            systemImage: "note.text",
                            title: vm.selectedCategory == nil ? "No lists yet" : "No \(vm.selectedCategory!.displayName) lists",
                            subtitle: vm.selectedCategory == nil
                                ? "Tap + to create your first sticky list"
                                : "Create a list in this category to see it here"
                        )
                    } else {
                        MasonryGridView(
                            notes: displayedNotes,
                            onToggleItem: { noteId, itemId in
                                vm.toggleChecklistItem(noteId: noteId, itemId: itemId)
                            },
                            onEdit: { note in noteToEdit = note },
                            onArchive: { id in vm.archiveNote(id: id) },
                            onDelete: { id in
                                noteToDelete = displayedNotes.first { $0.id == id }
                                showDeleteConfirm = true
                            }
                        )
                    }
                }

                // Floating add button
                Button(action: { showingAddNote = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.pastelBlue, in: Circle())
                        .shadow(color: Color.pastelBlue.opacity(0.4), radius: 10, x: 0, y: 4)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 24)
            }
            .navigationTitle("sticky lists")
            .background(Color(.systemGray6))
            .toolbarTitleDisplayMode(.large)
            .onAppear {
                let roundedFont = UIFont.systemFont(ofSize: 34, weight: .bold).withTraits(.traitBold).rounded()
                let pastelPink = UIColor(red: 1.0, green: 0.82, blue: 0.86, alpha: 1.0)
                UINavigationBar.appearance().largeTitleTextAttributes = [
                    .font: roundedFont,
                    .foregroundColor: pastelPink
                ]
            }
        }
        .sheet(isPresented: $showingAddNote) {
            NoteEditorSheet()
                .environmentObject(vm)
        }
        .sheet(item: $noteToEdit) { note in
            NoteEditorSheet(editingNote: note)
                .environmentObject(vm)
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
}
// MARK: - UIFont Extension for Rounded Font
extension UIFont {
    func rounded() -> UIFont {
        guard let descriptor = fontDescriptor.withDesign(.rounded) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: pointSize)
    }
    
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}

