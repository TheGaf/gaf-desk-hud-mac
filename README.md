# Desk HUD — macOS Bar Display App (Phase 1)

Phase 1 scaffold for DeskHUD: an always-on-top SwiftUI macOS HUD designed for ultra-wide bar displays (1920×480 target).

Features in this scaffold:
- Always-on-top borderless window sized to a selected display (auto-detect + manual override)
- 5 horizontal tiles: Now Playing (mock), Next Meeting (mock), Today Focus (editable), Clock (live), VIP Alerts (mock)
- Live clock (1s updates with seconds)
- Editable Focus tile persisted to UserDefaults (1–3 tasks)
- Liquid-glass tile styling using NSVisualEffectView wrapper
- Settings overlay to pick target display (applies instantly)

Open this repository in Xcode (File → Open) and open the Package.swift or build the target in Xcode 14+.

License: MIT
