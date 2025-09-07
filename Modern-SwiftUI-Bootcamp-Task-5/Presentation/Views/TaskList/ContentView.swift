//
//  ContentView.swift
//  Modern-SwiftUI-Bootcamp-Task-5
//
//  Created by Kürşat Şimşek on 6.09.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: TaskListViewModel
    @State private var newTaskTitle: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    TextField("Yeni görev ekle", text: $newTaskTitle)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .onSubmit(addTask)

                    Button(action: addTask) {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title3)
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel("Görev ekle")
                    .disabled(newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }

                List {
                    if viewModel.tasks.isEmpty {
                        ContentUnavailableView(
                            "Henüz görev yok",
                            systemImage: "checklist",
                            description: Text("Yeni bir görev eklemek için üstteki alana yazıp + butonuna dokunun.")
                        )
                    } else {
                        ForEach(viewModel.tasks) { task in
                            TaskRow(
                                task: task,
                                onToggle: {
                                    Task { await viewModel.toggleCompletion(for: task) }
                                }
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                Task { await viewModel.toggleCompletion(for: task) }
                            }
                        }
                        .onDelete { offsets in
                            Task { await viewModel.delete(at: offsets) }
                        }
                    }
                }
                .overlay {
                    if viewModel.isLoading {
                        ProgressView().controlSize(.regular)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Görevler")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !viewModel.tasks.isEmpty {
                        Menu {
                            Button("Örnekleri Yükle") {
                                Task { await viewModel.loadSample() }
                            }
                            Button("Tümünü Sil", role: .destructive) {
                                Task {
                                    await viewModel.delete(at: IndexSet(viewModel.tasks.indices))
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .task {
                await viewModel.refresh()
            }
            .onAppear {
                viewModel.onAppear()
            }
        }
    }

    private func addTask() {
        let trimmed = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        Task {
            await viewModel.addTask(title: trimmed)
            await MainActor.run { newTaskTitle = "" }
        }
    }
}

#Preview {
    // Preview için geçici container
    let container = AppContainer()
    ContentView(viewModel: container.makeTaskListViewModel())
}
