
import SwiftUI

@main
struct CleanCopyApp: App {
    @StateObject private var state = AppState()
    var body: some Scene {
        MenuBarExtra("PlainCopy", systemImage: "doc.on.doc"){
            Button("About CleanCopy "){About.show()}
            Divider()
            Toggle("Enabled", isOn:$state.enabled)
            Toggle("Launch at login", isOn: $state.launchAtLogin)
            Divider()
            Button("Quit") {NSApp.terminate(nil)}
        }
    }
}
