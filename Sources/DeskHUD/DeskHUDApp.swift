// DeskHUDApp.swift
// DeskHUD - Phase 1 scaffold
//
// Entry point for DeskHUD macOS SwiftUI app.
// Creates the SwiftUI lifecycle and wires AppDelegate which constructs a borderless always-on-top window.

import SwiftUI

@main
struct DeskHUDApp: App {
    // AppDelegate handles the custom NSWindow creation and lifecycle.
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // Shared models we want available app-wide
    @StateObject private var clockModel = ClockModel()
    @StateObject private var focusModel = FocusModel()

    var body: some Scene {
        // Keep a hidden WindowGroup so the app lifecycle remains active;
        // the visible window is created and managed by AppDelegate.
        WindowGroup {
            EmptyView()
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "*"))
        .environmentObject(clockModel)
        .environmentObject(focusModel)
    }
}
