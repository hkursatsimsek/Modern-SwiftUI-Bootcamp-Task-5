//
//  TaskRepository.swift
//  Modern-SwiftUI-Bootcamp-Task-5
//
//  Created by Kürşat Şimşek on 6.09.2025.
//

import Foundation

protocol TaskRepository {
    func loadTasks() async throws -> [TodoItem]
    func addTask(title: String) async throws -> TodoItem
    func toggleCompletion(id: UUID) async throws -> TodoItem
    func deleteTask(id: UUID) async throws
    func loadSampleTasks() async throws -> [TodoItem]
}
