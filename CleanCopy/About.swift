import SwiftUI
import AppKit

enum About {
    private static var window: NSWindow?
    
    static func show() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"

        let content = AboutView(version: version, build: build)

        let aboutWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 340, height: 220),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        aboutWindow.center()
        aboutWindow.title = "About CleanCopy"
        aboutWindow.contentView = NSHostingView(rootView: content)
        aboutWindow.isReleasedWhenClosed = false
        aboutWindow.makeKeyAndOrderFront(nil)
        window = aboutWindow
        
        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: aboutWindow,
            queue: .main
        ) { _ in
            window = nil
        }

        NSApp.activate(ignoringOtherApps: true)
    }
}

struct AboutView: View {
    let version: String
    let build: String

    var body: some View {
        VStack(spacing: 12) {
            Text("PlainCopy")
                .font(.title2).bold()

            Text("Makes all copied text plain")
                .foregroundColor(.secondary)

            Text("Version \(version) (\(build))")
                .font(.subheadline)

            Divider()

            Link("Check the code on GitHub",
                 destination: URL(string: "https://github.com/yujirot0627/CleanCopy")!)
                .font(.body)

            Text("© \(Calendar.current.component(.year, from: Date())) Yujiro")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 300)
    }
}
