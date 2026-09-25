import AppKit

let debounceSeconds = 1.0
let dotfilesPath = ProcessInfo.processInfo.environment["DOTFILES_PATH"] ?? "\(NSHomeDirectory())/.dotfiles"
let sdotPath = "\(dotfilesPath)/scripts/system/sdot"

var pendingSync: DispatchWorkItem?

func log(_ message: String) {
    let timestamp = ISO8601DateFormatter().string(from: Date())
    FileHandle.standardOutput.write(Data("\(timestamp) \(message)\n".utf8))
}

func syncMenuBarVisibility() {
    log("Syncing menu bar visibility")

    let process = Process()
    process.executableURL = URL(fileURLWithPath: sdotPath)
    process.arguments = ["mac", "toggle_menu_bar"]

    do {
        try process.run()
    } catch {
        FileHandle.standardError.write(Data("Failed to run \(sdotPath): \(error)\n".utf8))
    }
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
    log("Screen parameters changed, \(NSScreen.screens.count) screens connected")
    scheduleSync()
}

scheduleSync()

app.run()
