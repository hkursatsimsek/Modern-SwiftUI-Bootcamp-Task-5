//
//  TaskListViewModel.swift
//  Modern-SwiftUI-Bootcamp-Task-5
//
//  Created by Kürşat Şimşek on 6.09.2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class TaskListViewModel: ObservableObject {
    @Published private(set) var tasks: [TodoItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // Use Cases
    private let loadTasks: LoadTasksUseCase
    private let addTask: AddTaskUseCase
    private let toggleTaskCompletion: ToggleTaskCompletionUseCase
    private let deleteTask: DeleteTaskUseCase
    private let loadSampleTasks: LoadSampleTasksUseCase

    init(
        loadTasks: LoadTasksUseCase,
        addTask: AddTaskUseCase,
        toggleTaskCompletion: ToggleTaskCompletionUseCase,
        deleteTask: DeleteTaskUseCase,
        loadSampleTasks: LoadSampleTasksUseCase
    ) {
        self.loadTasks = loadTasks
        self.addTask = addTask
        self.toggleTaskCompletion = toggleTaskCompletion
        self.deleteTask = deleteTask
        self.loadSampleTasks = loadSampleTasks
    }

    // MARK: - Lifecycle

    func onAppear() {
        Task { await refresh() }
    }

    // MARK: - Intents (async)

    func refresh() async {
        await perform {
            let items = try await self.loadTasks()
            self.tasks = items
        }
    }

    func addTask(title: String) async {
        await perform {
            _ = try await self.addTask(title: title)
            let items = try await self.loadTasks()
            self.tasks = items
        }
    }

    func toggleCompletion(for task: TodoItem) async {
        await perform {
            _ = try await self.toggleTaskCompletion(id: task.id)
            if let idx = self.tasks.firstIndex(where: { $0.id == task.id }) {
                self.tasks[idx].isCompleted.toggle()
            } else {
                self.tasks = try await self.loadTasks()
            }
        }
    }

    func delete(at offsets: IndexSet) async {
        await perform {
            for index in offsets {
                let id = self.tasks[index].id
                try await self.deleteTask(id: id)
            }
            self.tasks.remove(atOffsets: offsets)
        }
    }

    func loadSample() async {
        await perform {
            let items = try await self.loadSampleTasks()
            self.tasks = items
        }
    }

    // MARK: - Helper

    private func perform(_ work: @escaping () async throws -> Void) async {
        isLoading = true
        errorMessage = nil
        do {
            try await work()
        } catch is CancellationError {
            // Ignore
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
