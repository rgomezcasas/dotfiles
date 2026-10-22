import AppKit

let debounceSeconds = 1.0

var pendingSync: DispatchWorkItem?

func log(_ message: String) {
    let timestamp = ISO8601DateFormatter().string(from: Date())
    FileHandle.standardOutput.write(Data("\(timestamp) \(message)\n".utf8))
}

func readGlobalBool(_ key: String) -> Bool {
    CFPreferencesCopyAppValue(key as CFString, kCFPreferencesAnyApplication) as? Bool ?? false
}

func writeGlobalBool(_ key: String, _ value: Bool) {
    CFPreferencesSetValue(
        key as CFString,
        value as CFBoolean,
        kCFPreferencesAnyApplication,
        kCFPreferencesCurrentUser,
        kCFPreferencesAnyHost
    )
}

func setMenuBarHidden(_ hidden: Bool) {
    writeGlobalBool("_HIHideMenuBar", hidden)
    writeGlobalBool("AppleMenuBarVisibleInFullscreen", false)
    CFPreferencesAppSynchronize(kCFPreferencesAnyApplication)

    DistributedNotificationCenter.default().postNotificationName(
        NSNotification.Name("AppleInterfaceMenuBarHidingChangedNotification"),
        object: nil,
        userInfo: nil,
        deliverImmediately: true
    )
}

func syncMenuBarVisibility() {
    let screensCount = NSScreen.screens.count
    let shouldBeHidden = screensCount > 1

    let isInDesiredState = readGlobalBool("_HIHideMenuBar") == shouldBeHidden
        && !readGlobalBool("AppleMenuBarVisibleInFullscreen")

    guard !isInDesiredState else { return }

    log("\(screensCount) screens connected, \(shouldBeHidden ? "hiding" : "showing") menu bar")
    setMenuBarHidden(shouldBeHidden)
}

func scheduleSync() {
    pendingSync?.cancel()

    let sync = DispatchWorkItem(block: syncMenuBarVisibility)
    pendingSync = sync

    DispatchQueue.main.asyncAfter(deadline: .now() + debounceSeconds, execute: sync)
}

let app = NSApplication.shared
app.setActivationPolicy(.prohibited)

NotificationCenter.default.addObserver(
    forName: NSApplication.didChangeScreenParametersNotification,
    object: nil,
    queue: .main
) { _ in
    scheduleSync()
}

scheduleSync()

app.run()
