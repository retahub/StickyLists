import SwiftUI

struct ContentView: View {
    @StateObject private var vm = NotesViewModel()

    var body: some View {
        TabView {
            HomeView()
                .environmentObject(vm)
                .tabItem {
                    Label("Lists", systemImage: "note.text")
                }

            ArchiveView()
                .environmentObject(vm)
                .tabItem {
                    Label("Archive", systemImage: "archivebox")
                }
        }
        .tint(.pastelBlue)
    }
}
