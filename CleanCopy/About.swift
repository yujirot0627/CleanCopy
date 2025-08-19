import AppKit

enum About {
    static func show() {
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
                    ?? ProcessInfo.processInfo.processName
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "—"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "—"

        // Optional extra text: credits / blurb
        let credits = """
        PlainCopy — makes all copied text plain.
        © \(Calendar.current.component(.year, from: Date())) You.
        """

        let options: [NSApplication.AboutPanelOptionKey: Any] = [
            .applicationName: name,
            .applicationVersion: "Version \(version) (\(build))",
            .credits: credits
        ]

        NSApp.activate(ignoringOtherApps: true) // bring to front
        NSApp.orderFrontStandardAboutPanel(options: options)
    }
}
