import Foundation

enum FirstUsageManager {
    static func markAsOpened() {
        UserDefaults.standard.set(true, forKey: "opened")
    }
    static func checkIfAppsFirstUse()->Bool {
        return UserDefaults.standard.bool(forKey: "opened")
    }
}
