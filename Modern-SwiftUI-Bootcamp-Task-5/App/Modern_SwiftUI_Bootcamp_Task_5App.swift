//
//  Modern_SwiftUI_Bootcamp_Task_5App.swift
//  Modern-SwiftUI-Bootcamp-Task-5
//
//  Created by Kürşat Şimşek on 6.09.2025.
//

import SwiftUI
import SwiftData

@main
struct Modern_SwiftUI_Bootcamp_Task_5App: App {

    // DI Container
    private let container: AppContainer

    init() {
        self.container = AppContainer()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: container.makeTaskListViewModel())
        }
        .modelContainer(container.modelContainer)
    }
}

