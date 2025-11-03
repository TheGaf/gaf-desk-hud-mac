// AppDelegate.swift
// Creates a borderless always-on-top window sized to the bar monitor (auto-detect or override).
// Attaches a SwiftUI ContentView as the window content and wires environment models.

import Cocoa
import SwiftUI

extension Notification.Name {
    // Notification used to request an immediate screen change/reposition of the HUD window.
    static let deskHUDDidRequestScreenChange = Notification.Name("DeskHUDDidRequestScreenChange")
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    let clockModel = ClockModel()
    let focusModel = FocusModel()

    private let preferredScreenIndexKey = "DeskHUD.PreferredScreenIndex"

    func applicationDidFinishLaunching(_ notification: Notification) {
        focusModel.loadFromDefaults()

        // Create the window for the selected screen
        let targetScreen = selectScreen()
        createWindow(for: targetScreen)

        // Create SwiftUI ContentView and inject environment objects.
        let contentView = ContentView()
            .environmentObject(clockModel)
            .environmentObject(focusModel)

        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)

        // Start models
        clockModel.start()
        focusModel.startAutoSave()

        // Observe app termination to save state
        NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminate), name: NSApplication.willTerminateNotification, object: nil)

        // Observe requests to change target display instantly
        NotificationCenter.default.addObserver(self, selector: #selector(handleScreenChangeNotification(_:)), name: .deskHUDDidRequestScreenChange, object: nil)
    }

    @objc func appWillTerminate() {
        clockModel.stop()
        focusModel.saveToDefaults()
    }

    // Create and configure the borderless HUD window for a given screen.
    private func createWindow(for screen: NSScreen) {
        let frame = screen.frame
        window = NSWindow(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false, screen: screen)
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = false
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenNone, .stationary]
        window.ignoresMouseEvents = false
        window.isMovableByWindowBackground = false
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
    }

    // Handle notification to reposition HUD immediately.
    @objc private func handleScreenChangeNotification(_ note: Notification) {
        // If user provided a specific screen index, reposition to that screen.
        if let idx = note.userInfo?["screenIndex"] as? Int {
            repositionWindow(toScreenIndex: idx)
            return
        }
        // If autoDetect requested
        if let auto = note.userInfo?["autoDetect"] as? Bool, auto == true {
            repositionWindowToAutoDetectedScreen()
        }
    }

    // Reposition window to a given screen index (if valid)
    private func repositionWindow(toScreenIndex idx: Int) {
        let screens = NSScreen.screens
        guard idx >= 0 && idx < screens.count else { return }
        let target = screens[idx]
        DispatchQueue.main.async {
            // Change the window's screen and frame
            self.window.setFrame(target.frame, display: true, animate: true)
            self.window.screen = target
            // Reapply level & behaviors to ensure HUD stays on top
            self.window.level = .floating
            self.window.collectionBehavior = [.canJoinAllSpaces, .fullScreenNone, .stationary]
        }
        // Persist override
        UserDefaults.standard.set(idx, forKey: preferredScreenIndexKey)
    }

    // Re-run heuristic and reposition to best-matching screen
    private func repositionWindowToAutoDetectedScreen() {
        let target = selectScreen()
        DispatchQueue.main.async {
            self.window.setFrame(target.frame, display: true, animate: true)
            self.window.screen = target
            self.window.level = .floating
            self.window.collectionBehavior = [.canJoinAllSpaces, .fullScreenNone, .stationary]
        }
        // Clear stored override
        UserDefaults.standard.removeObject(forKey: preferredScreenIndexKey)
    }

    // Screen selection heuristic (used for initial placement and auto-detect)
    private func selectScreen() -> NSScreen {
        let screens = NSScreen.screens

        // Respect stored manual override
        if let idx = UserDefaults.standard.object(forKey: preferredScreenIndexKey) as? Int, idx >= 0, idx < screens.count {
            return screens[idx]
        }

        // Heuristic score
        var best: NSScreen = NSScreen.main ?? screens.first!
        var bestScore: Double = -Double.infinity

        for s in screens {
            let size = s.frame.size
            guard size.width > 0 && size.height > 0 else { continue }
            let aspect = Double(size.width / size.height)
            let aspectScore = max(0, aspect - 2.0)
            let heightScore = 1.0 - abs((Double(size.height) - 480.0) / 800.0)
            let score = aspectScore * 2.0 + heightScore
            if score > bestScore {
                bestScore = score
                best = s
            }
        }

        return best
    }
}