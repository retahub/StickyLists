import SwiftUI

struct NoteEditorSheet: View {
    @EnvironmentObject var vm: NotesViewModel
    @Environment(\.dismiss) private var dismiss

    var editingNote: StickyNote? = nil

    @State private var title: String = ""
    @State private var checklist: [ChecklistItem] = []
    @State private var selectedCategory: NoteCategory = .personal
    @State private var selectedColorName: String = Color.defaultPastelName
    @State private var newItemText: String = ""
    @FocusState private var newItemFocused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Preview card
                    previewCard
                        .padding(.horizontal)
                        .padding(.top, 8)

                    // Color picker
                    VStack(alignment: .leading, spacing: 10) {
                        sectionLabel("Color")
                        colorPicker
                    }
                    .padding(.horizontal)

                    // Category picker
                    VStack(alignment: .leading, spacing: 10) {
                        sectionLabel("Category")
                        categoryPicker
                    }
                    .padding(.horizontal)

                    // Title field
                    VStack(alignment: .leading, spacing: 8) {
                        sectionLabel("Title")
                        TextField("List title...", text: $title)
                            .font(.system(size: 16, weight: .semibold))
                            .padding(12)
                            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)

                    // Checklist
                    VStack(alignment: .leading, spacing: 10) {
                        sectionLabel("Checklist")
                        checklistEditor
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(editingNote == nil ? "New List" : "Edit List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear { seedIfEditing() }
        }
    }

    // MARK: - Sub-views

    private var previewCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Image(systemName: selectedCategory.systemIcon)
                    .font(.system(size: 10, weight: .semibold))
                Text(selectedCategory.displayName)
                    .font(.system(size: 11, weight: .semibold))
            }
            .foregroundColor(.pastelDark(named: selectedColorName))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.pastelDark(named: selectedColorName).opacity(0.15), in: Capsule())

            Text(title.isEmpty ? "Your list title" : title)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(title.isEmpty ? .secondary : .primary.opacity(0.85))
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.pastel(named: selectedColorName), in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.pastelDark(named: selectedColorName).opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.pastelDark(named: selectedColorName).opacity(0.15), radius: 6, x: 0, y: 3)
    }

    private var colorPicker: some View {
        HStack(spacing: 12) {
            ForEach(Color.pastelColorOrder, id: \.self) { name in
                Button(action: { withAnimation(.spring(response: 0.3)) { selectedColorName = name } }) {
                    ZStack {
                        Circle()
                            .fill(Color.pastel(named: name))
                            .frame(width: 36, height: 36)
                            .shadow(color: Color.pastelDark(named: name).opacity(0.3), radius: 3)
                        if selectedColorName == name {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color.pastelDark(named: name))
                        }
                    }
                    .scaleEffect(selectedColorName == name ? 1.2 : 1.0)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var categoryPicker: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
            ForEach(NoteCategory.allCases) { cat in
                Button(action: { withAnimation(.spring(response: 0.3)) { selectedCategory = cat } }) {
                    VStack(spacing: 5) {
                        Image(systemName: cat.systemIcon)
                            .font(.system(size: 18))
                        Text(cat.displayName)
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        selectedCategory == cat
                            ? Color.pastelBlue.opacity(0.12)
                            : Color(.systemGray6)
                    )
                    .foregroundColor(selectedCategory == cat ? .pastelBlue : .secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(selectedCategory == cat ? Color.pastelBlue.opacity(0.4) : .clear, lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var checklistEditor: some View {
        VStack(spacing: 0) {
            if !checklist.isEmpty {
                ForEach(Array(checklist.enumerated()), id: \.element.id) { idx, item in
                    HStack(spacing: 10) {
                        // Drag handle
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary.opacity(0.5))

                        Button(action: { checklist[idx].isChecked.toggle() }) {
                            Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 18))
                                .foregroundColor(item.isChecked ? .green : .secondary)
                        }
                        .buttonStyle(.plain)

                        TextField("Item...", text: $checklist[idx].text)
                            .font(.system(size: 14))
                            .strikethrough(item.isChecked, color: .secondary)

                        Button(action: { checklist.remove(at: idx) }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary.opacity(0.4))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(.systemBackground))

                    if idx < checklist.count - 1 {
                        Divider().padding(.leading, 52)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Add item row
            HStack(spacing: 10) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.pastelBlue)

                TextField("Add item...", text: $newItemText)
                    .font(.system(size: 14))
                    .focused($newItemFocused)
                    .onSubmit { addItem() }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                checklist.isEmpty
                    ? Color(.systemBackground)
                    : Color(.systemBackground)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color(.systemGray5), lineWidth: 1)
            )
            .padding(.top, checklist.isEmpty ? 0 : 8)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            checklist.isEmpty ? nil :
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color(.systemGray5), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.secondary)
            .textCase(.uppercase)
    }

    // MARK: - Actions

    private func addItem() {
        let trimmed = newItemText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        checklist.append(ChecklistItem(text: trimmed))
        newItemText = ""
        newItemFocused = true
    }

    private func save() {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        if let existing = editingNote {
            var updated = existing
            updated.title = title
            updated.checklist = checklist
            updated.category = selectedCategory
            updated.colorName = selectedColorName
            vm.updateNote(updated)
        } else {
            let note = StickyNote(
                title: title,
                checklist: checklist,
                category: selectedCategory,
                colorName: selectedColorName
            )
            vm.addNote(note)
        }
        dismiss()
    }

    private func seedIfEditing() {
        guard let note = editingNote else { return }
        title = note.title
        checklist = note.checklist
        selectedCategory = note.category
        selectedColorName = note.colorName
    }
}
