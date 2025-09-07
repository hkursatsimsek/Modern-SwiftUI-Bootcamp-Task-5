//
//  TaskRow.swift
//  Modern-SwiftUI-Bootcamp-Task-5
//
//  Created by Kürşat Şimşek on 6.09.2025.
//

import SwiftUI

struct TaskRow: View {
    let task: TodoItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.isCompleted ? .green : .secondary)
                    .font(.title3)
                    .accessibilityLabel(task.isCompleted ? "Tamamlandı olarak işaretlemeden kaldır" : "Tamamlandı olarak işaretle")
            }
            .buttonStyle(.plain)

            Text(task.title)
                .font(.body)
                .foregroundStyle(task.isCompleted ? .secondary : .primary)
                .strikethrough(task.isCompleted, pattern: .solid, color: .secondary)

            Spacer()
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Dokunarak tamamlama durumunu değiştirin")
    }
}

#Preview {
    TaskRow(task: TodoItem(title: "Örnek görev"), onToggle: {})
}
