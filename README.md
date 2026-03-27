# Sticky Lists

A minimalist checklist app for iOS built with SwiftUI and Claude AI. Create and organize your to-do lists with colorful sticky note-style cards. 

## Features

### Core Functionality
- **Create Custom Lists**: Build checklists for any purpose with a simple, intuitive interface
- **Category Organization**: Organize lists by categories (Personal, Work, Shopping, Travel, etc.)
- **Interactive Checklists**: Check off items as you complete them with smooth animations
- **Progress Tracking**: Visual progress bars show completion status at a glance
- **Archive Completed Lists**: Keep your active view clean by archiving finished lists

### Design
- **Pastel Color Palette**: Choose from a variety of soft, pleasant colors for each list
- **Masonry Grid Layout**: Cards automatically arrange in an elegant, Pinterest-style grid
- **Light Grey Background**: Easy on the eyes with a subtle, modern aesthetic
- **Category Badges**: Quickly identify list types with colored icons and labels
- **Completion Celebrations**: "All done!" banner appears when lists are completed

### List Management
- **Edit Anytime**: Modify lists, add/remove items, change colors and categories
- **Archive System**: Store completed lists in a dedicated archive tab
- **Restore from Archive**: Bring back archived lists when needed
- **Delete Confirmation**: Protect against accidental deletions with confirmation dialogs
- **Persistent Storage**: All data is automatically saved locally

## User Interface

### Main Tab Bar
- **Lists Tab**: View all active checklists, filter by category
- **Archive Tab**: Access completed and archived lists

### Home View
- Category filter bar to show all lists or filter by specific categories
- Floating "+" button to create new lists
- Empty state guidance when no lists exist
- Three-dot menu on each card for quick actions (Edit, Archive, Delete)

### Archive View
- Browse all archived lists
- Restore lists back to active status
- Permanently delete old lists
- View completion details and category info

## Technical Details

### Architecture
- **Framework**: SwiftUI
- **Platform**: iOS
- **Data Persistence**: Local storage using Codable and UserDefaults/FileManager
- **State Management**: MVVM pattern with `@StateObject` and `@EnvironmentObject`

### Key Components
- `StickyNote`: Core data model with categories, checklists, and metadata
- `NotesViewModel`: Manages all list operations and state
- `MasonryGridView`: Custom masonry layout for card display
- `NoteCardView`: Reusable card component with progress tracking
- `NoteEditorSheet`: Full-screen editor for creating/editing lists

### Categories
Built-in categories with custom icons:
- 📋 Personal
- 💼 Work
- 🛒 Shopping
- ✈️ Travel
- 🏋️ Fitness
- 📚 Learning
- 🏠 Home
- 🎯 Goals
- 🎉 Events
- 💡 Ideas

### Color Themes
Multiple pastel color options:
- Pink
- Blue
- Green
- Yellow
- Purple
- Orange
- Mint
- Peach

## Getting Started

### Requirements
- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

### Installation
1. Clone or download this repository
2. Open `StickyLists.xcodeproj` in Xcode
3. Select your target device or simulator
4. Press `Cmd + R` to build and run

### Usage
1. **Create a List**: Tap the floating "+" button
2. **Add Items**: Enter a title, select a category and color, then add checklist items
3. **Check Off Items**: Tap circles next to items to mark them complete
4. **Filter Lists**: Use the category bar to view specific types of lists
5. **Archive Completed**: When all items are checked, tap "Archive" to move to archive
6. **Edit or Delete**: Use the three-dot menu on any card for more options

## Project Structure

```
StickyLists/
├── Models/
│   ├── StickyNote.swift          # Main note data model
│   ├── ChecklistItem.swift       # Individual checklist items
│   └── NoteCategory.swift        # Category enum with icons
├── ViewModels/
│   └── NotesViewModel.swift      # Business logic and state management
├── Views/
│   ├── ContentView.swift         # Main tab view container
│   ├── HomeView.swift            # Active lists view
│   ├── ArchiveView.swift         # Archived lists view
│   ├── NoteCardView.swift        # Individual note card
│   ├── NoteEditorSheet.swift    # Create/edit sheet
│   ├── MasonryGridView.swift    # Custom layout
│   ├── CategoryFilterBar.swift  # Category selector
│   ├── ChecklistItemRow.swift   # Checklist item UI
│   └── EmptyStateView.swift     # Empty state messages
├── Extensions/
│   └── Color+Pastel.swift        # Custom color extensions
└── StickyListsApp.swift          # App entry point
```

## Customization

### Adding New Categories
Edit `NoteCategory.swift` to add new category types:
```swift
enum NoteCategory: String, Codable, CaseIterable {
    case yourNewCategory
    // Add display name and icon in computed properties
}
```

### Adding New Colors
Extend `Color+Pastel.swift` with new color definitions:
```swift
static let pastelYourColor = Color(red: 0.xx, green: 0.xx, blue: 0.xx)
```

### Adjusting Layout
Modify `MasonryGridView.swift` to customize:
- Number of columns
- Card spacing
- Grid padding
- Animation timing


