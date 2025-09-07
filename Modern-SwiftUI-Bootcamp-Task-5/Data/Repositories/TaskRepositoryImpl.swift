//
//  TaskRepositoryImpl.swift
//  Modern-SwiftUI-Bootcamp-Task-5
//
//  Created by Kürşat Şimşek on 6.09.2025.
//

import Foundation

final class TaskRepositoryImpl: TaskRepository {
    private let dataSource: TaskSwiftDataDataSource

    init(dataSource: TaskSwiftDataDataSource) {
        self.dataSource = dataSource
    }

    func loadTasks() async throws -> [TodoItem] {
        try checkCancellation()
        let entities = try dataSource.fetchAll()
        return entities.map(TaskMapper.toDomain)
    }

    func addTask(title: String) async throws -> TodoItem {
        try checkCancellation()
        let domain = TodoItem(title: title)
        let entity = TaskMapper.toEntity(domain)
        try dataSource.insert(entity)
        try dataSource.saveIfNeeded()
        return domain
    }

    func toggleCompletion(id: UUID) async throws -> TodoItem {
        try checkCancellation()
        guard let entity = try dataSource.fetch(by: id) else {
            throw RepositoryError.notFound
        }
        entity.isCompleted.toggle()
        try dataSource.saveIfNeeded()
        return TaskMapper.toDomain(entity)
    }

    func deleteTask(id: UUID) async throws {
        try checkCancellation()
        guard let entity = try dataSource.fetch(by: id) else {
            throw RepositoryError.notFound
        }
        try dataSource.delete(entity)
        try dataSource.saveIfNeeded()
    }

    func loadSampleTasks() async throws -> [TodoItem] {
        try checkCancellation()
        let samples: [TodoItem] = [
            TodoItem(title: "Alışveriş yap"),
            TodoItem(title: "30 dk yürüyüş", isCompleted: true),
            TodoItem(title: "SwiftUI pratik"),
            TodoItem(title: "E-postaları kontrol et")
        ]
        for sample in samples {
            let entity = TaskMapper.toEntity(sample)
            try dataSource.insert(entity)
        }
        try dataSource.saveIfNeeded()
        return try dataSource.fetchAll().map(TaskMapper.toDomain)
    }
}

// Basit hata türü
enum RepositoryError: Error {
    case notFound
}

@inline(__always)
private func checkCancellation() throws {
    // Swift Concurrency Task
    try Task.checkCancellation()
}
