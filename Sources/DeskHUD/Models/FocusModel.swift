// Models/FocusModel.swift
// Stores up to 1-3 focus tasks, persisted to UserDefaults in the app sandbox.

import Foundation
import Combine

final class FocusModel: ObservableObject {
    @Published var tasks: [String] = [""]

    private let defaultsKey = "DeskHUD.FocusTasks.v1"
    private var cancellables = Set<AnyCancellable>()

    init() {
        $tasks
            .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.saveToDefaults()
            }
            .store(in: &cancellables)
    }

    func loadFromDefaults() {
        if let saved = UserDefaults.standard.array(forKey: defaultsKey) as? [String], !saved.isEmpty {
            tasks = saved
        } else {
            tasks = ["Focus: Finish report", "Call Alice at 15:00", "Stand-up notes"]
        }
    }

    func saveToDefaults() {
        let trimmed = tasks.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        UserDefaults.standard.set(trimmed, forKey: defaultsKey)
    }

    func startAutoSave() {
        // placeholder for future
    }

    func addTask() {
        guard tasks.count < 3 else { return }
        tasks.append("")
    }

    func removeTask(at index: Int) {
        guard tasks.indices.contains(index) else { return }
        tasks.remove(at: index)
    }
}