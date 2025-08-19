import Foundation

final class AppState: ObservableObject {
    @Published var enabled: Bool {
            didSet {
                UserDefaults.standard.set(enabled, forKey: "enabled")
                if enabled {
                    cleaner.start()
                } else {
                    cleaner.stop()
                }
            }
        }

        @Published var allowlist: [String] {
            didSet {
                UserDefaults.standard.set(allowlist, forKey: "allowlist")
                cleaner.shouldSkipBundleIDs = Set(allowlist)
            }
        }

        @Published var launchAtLogin: Bool {
            didSet {
                LoginItem.setEnabled(launchAtLogin)
                UserDefaults.standard.set(launchAtLogin, forKey: "launchAtLogin")
            }
        }

    let cleaner = CleanCopy()

    init() {
        enabled = UserDefaults.standard.object(forKey: "enabled") as? Bool ?? true
        allowlist = UserDefaults.standard.stringArray(forKey: "allowlist") ?? defaultAllowlist
        launchAtLogin = UserDefaults.standard.object(forKey: "launchAtLogin") as? Bool ?? false
        cleaner.shouldSkipBundleIDs = Set(allowlist)
        if enabled {
            cleaner.start()
        }
        
    }
}

let defaultAllowlist: [String] = [
    "com.1password.1password", "com.bitwarden.desktop",
    "com.googlecode.iterm2", "com.apple.Terminal"
]
