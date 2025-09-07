//
//  TaskSwiftDataDataSource.swift
//  Modern-SwiftUI-Bootcamp-Task-5
//
//  Created by Kürşat Şimşek on 6.09.2025.
//

import Foundation
import SwiftData

protocol TaskSwiftDataReadable {
    func fetchAll() throws -> [TaskEntity]
    func fetch(by id: UUID) throws -> TaskEntity?
}

protocol TaskSwiftDataWritable {
    func insert(_ entity: TaskEntity) throws
    func delete(_ entity: TaskEntity) throws
    func saveIfNeeded() throws
}

final class TaskSwiftDataDataSource: TaskSwiftDataReadable, TaskSwiftDataWritable {
    private let context: ModelContext

    init(modelContext: ModelContext) {
        self.context = modelContext
    }

    func fetchAll() throws -> [TaskEntity] {
        let descriptor = FetchDescriptor<TaskEntity>()
        let items = try context.fetch(descriptor)

        // Önce tamamlanmamışlar, sonra createdAt'e göre azalan (yeni > eski)
        return items.sorted { lhs, rhs in
            if lhs.isCompleted != rhs.isCompleted {
                return lhs.isCompleted == false && rhs.isCompleted == true
            }
            return lhs.createdAt > rhs.createdAt
        }
    }

    // Bellekte filtreleme
    func fetch(by id: UUID) throws -> TaskEntity? {
        let descriptor = FetchDescriptor<TaskEntity>()
        return try context.fetch(descriptor).first { $0.id == id }
    }

    func insert(_ entity: TaskEntity) throws {
        context.insert(entity)
    }

    func delete(_ entity: TaskEntity) throws {
        context.delete(entity)
    }

    func saveIfNeeded() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
