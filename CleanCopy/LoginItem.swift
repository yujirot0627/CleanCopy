import ServiceManagement

enum LoginItem {
    static func setEnabled(_ enabled: Bool) {
        do {
            if enabled { try SMAppService.mainApp.register() }
            else { try SMAppService.mainApp.unregister() }
        } catch {
            NSLog("Login item error: \(error.localizedDescription)")
        }
    }
}
