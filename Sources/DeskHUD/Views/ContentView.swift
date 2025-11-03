import SwiftUI
import AppKit

struct ContentView: View {
    @EnvironmentObject var clockModel: ClockModel
    @EnvironmentObject var focusModel: FocusModel

    @State private var showSettings: Bool = false
    @State private var screens: [NSScreen] = NSScreen.screens
    @State private var selectedScreenIndex: Int? = nil
    private let preferredScreenIndexKey = "DeskHUD.PreferredScreenIndex"

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topTrailing) {
                Color.clear

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 12) {
                        PlaceholderTile(title: "Now Playing", subtitle: "Mock track — Artist Name")
                        PlaceholderTile(title: "Next Meeting", subtitle: "Mock event • 14:30 — In 10 min")
                        FocusTile().environmentObject(focusModel)
                        ClockTile().environmentObject(clockModel)
                        PlaceholderTile(title: "VIP Alerts", subtitle: "0 silent alerts")
                    }
                    .padding(.vertical, 18)
                    .padding(.horizontal, 22)
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .leading)

                VStack {
                    HStack {
                        Button(action: { toggleSettings() }) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.35))
                                .clipShape(Circle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(12)
                    }
                    Spacer()
                }

                if showSettings {
                    settingsPanel
                        .padding(.top, 56)
                        .padding(.trailing, 12)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .onAppear {
            screens = NSScreen.screens
            if let idx = UserDefaults.standard.object(forKey: preferredScreenIndexKey) as? Int {
                selectedScreenIndex = idx
            } else {
                selectedScreenIndex = nil
            }
        }
    }

    private var settingsPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DeskHUD Settings")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(.white)

            Text("Target display (manual override). Changes apply instantly.")
                .font(.system(size: 11))
                .foregroundColor(Color.white.opacity(0.85))

            Divider().background(Color.white.opacity(0.06))

            ForEach(screens.indices, id: \.self) { idx in
                let s = screens[idx]
                Button(action: {
                    selectedScreenIndex = idx
                    UserDefaults.standard.set(idx, forKey: preferredScreenIndexKey)
                    // Post notification to request immediate reposition
                    NotificationCenter.default.post(name: .deskHUDDidRequestScreenChange, object: nil, userInfo: ["screenIndex": idx])
                }) {
                    HStack {
                        Text("Display \(idx + 1) — \(Int(s.frame.width))×\(Int(s.frame.height))")
                            .foregroundColor(.white)
                        Spacer()
                        if selectedScreenIndex == idx {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }

            Button(action: {
                UserDefaults.standard.removeObject(forKey: preferredScreenIndexKey)
                selectedScreenIndex = nil
                // trigger auto-detect and reposition instantly
                NotificationCenter.default.post(name: .deskHUDDidRequestScreenChange, object: nil, userInfo: ["autoDetect": true])
            }) {
                Text("Use auto-detect heuristic")
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())

            Divider().background(Color.white.opacity(0.06))

            Text("Tip: Display changes apply instantly. If you change the physical display arrangement, close & reopen the app to recreate the window if needed.")
                .font(.system(size: 10))
                .foregroundColor(Color.white.opacity(0.75))

            HStack {
                Spacer()
                Button("Close") { showSettings = false }
                    .keyboardShortcut(.escape, modifiers: [])
            }
        }
        .padding(12)
        .background(VisualEffectBlur(material: .hudWindow, cornerRadius: 12))
        .frame(width: 320)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.06)))
    }

    private func toggleSettings() {
        withAnimation(.easeInOut(duration: 0.12)) {
            showSettings.toggle()
        }
    }
}