//
//  DeleteTaskUseCase.swift
//  Modern-SwiftUI-Bootcamp-Task-5
//
//  Created by Kürşat Şimşek on 6.09.2025.
//

import Foundation

struct DeleteTaskUseCase {
    private let repository: TaskRepository

    init(repository: TaskRepository) {
        self.repository = repository
    }

    func callAsFunction(id: UUID) async throws {
        try await repository.deleteTask(id: id)
    }
}
