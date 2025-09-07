//
//  TaskMapper.swift
//  Modern-SwiftUI-Bootcamp-Task-5
//
//  Created by Kürşat Şimşek on 6.09.2025.
//

import Foundation

enum TaskMapper {
    static func toDomain(_ entity: TaskEntity) -> TodoItem {
        TodoItem(id: entity.id, title: entity.title, isCompleted: entity.isCompleted)
    }

    static func toEntity(_ model: TodoItem) -> TaskEntity {
        TaskEntity(id: model.id, title: model.title, isCompleted: model.isCompleted)
    }
}
