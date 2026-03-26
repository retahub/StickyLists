import SwiftUI

struct ChecklistItemRow: View {
    let item: ChecklistItem
    var onToggle: (() -> Void)? = nil

    var body: some View {
        Button(action: { onToggle?() }) {
            HStack(spacing: 8) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(item.isChecked ? .green : .secondary)
                    .animation(.spring(response: 0.3), value: item.isChecked)

                Text(item.text)
                    .font(.system(size: 14))
                    .foregroundColor(item.isChecked ? .secondary : .primary)
                    .strikethrough(item.isChecked, color: .secondary)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
        .disabled(onToggle == nil)
    }
}
