//
//  AppContainer.swift
//  Modern-SwiftUI-Bootcamp-Task-5
//
//  Created by Kürşat Şimşek on 6.09.2025.
//

import Foundation
import SwiftData

// Composition Root / DI Container
final class AppContainer {

    // SwiftData ModelContainer
    let modelContainer: ModelContainer

    // Data layer
    private let dataSource: TaskSwiftDataDataSource
    private let taskRepository: TaskRepository

    // Domain layer (Use Cases)
    private let loadTasksUseCase: LoadTasksUseCase
    private let addTaskUseCase: AddTaskUseCase
    private let toggleTaskCompletionUseCase: ToggleTaskCompletionUseCase
    private let deleteTaskUseCase: DeleteTaskUseCase
    private let loadSampleTasksUseCase: LoadSampleTasksUseCase

    init() {
        // SwiftData ModelContainer kurulum
        let schema = Schema([TaskEntity.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            self.modelContainer = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("ModelContainer oluşturulamadı: \(error)")
        }

        // DataSource & Repository
        self.dataSource = TaskSwiftDataDataSource(modelContext: modelContainer.mainContext)
        self.taskRepository = TaskRepositoryImpl(dataSource: dataSource)

        // Use Cases
        self.loadTasksUseCase = LoadTasksUseCase(repository: taskRepository)
        self.addTaskUseCase = AddTaskUseCase(repository: taskRepository)
        self.toggleTaskCompletionUseCase = ToggleTaskCompletionUseCase(repository: taskRepository)
        self.deleteTaskUseCase = DeleteTaskUseCase(repository: taskRepository)
        self.loadSampleTasksUseCase = LoadSampleTasksUseCase(repository: taskRepository)
    }

    // Factory for ViewModels
    func makeTaskListViewModel() -> TaskListViewModel {
        TaskListViewModel(
            loadTasks: loadTasksUseCase,
            addTask: addTaskUseCase,
            toggleTaskCompletion: toggleTaskCompletionUseCase,
            deleteTask: deleteTaskUseCase,
            loadSampleTasks: loadSampleTasksUseCase
        )
    }
}

