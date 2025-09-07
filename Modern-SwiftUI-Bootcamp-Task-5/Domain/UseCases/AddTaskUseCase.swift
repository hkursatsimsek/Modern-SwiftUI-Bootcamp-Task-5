//
//  AddTaskUseCase.swift
//  Modern-SwiftUI-Bootcamp-Task-5
//
//  Created by Kürşat Şimşek on 6.09.2025.
//

import Foundation

struct AddTaskUseCase {
    private let repository: TaskRepository

    init(repository: TaskRepository) {
        self.repository = repository
    }

    func callAsFunction(title: String) async throws -> TodoItem {
        try await repository.addTask(title: title)
    }
}
