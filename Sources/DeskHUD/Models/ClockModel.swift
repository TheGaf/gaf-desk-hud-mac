// Models/ClockModel.swift
// ObservableObject that provides the current time and date strings for the Clock tile.
// Uses Combine Timer publisher to update once per second.

import Foundation
import Combine

final class ClockModel: ObservableObject {
    @Published var timeString: String = ""
    @Published var dateString: String = ""

    private var timerCancellable: AnyCancellable?
    private let timeFormatter: DateFormatter
    private let dateFormatter: DateFormatter

    init() {
        timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.setLocalizedDateFormatFromTemplate("j:mm:ss")

        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EEE, MMM d"
        updateNow()
    }

    func start() {
        updateNow()
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateNow()
            }
    }

    func stop() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func updateNow() {
        let now = Date()
        timeString = timeFormatter.string(from: now)
        dateString = dateFormatter.string(from: now)
    }
}