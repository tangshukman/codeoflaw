//
//  SuitUpApp.swift
//  Shared
//
//  Created by 이지원 on 2022/06/27.
//

import SwiftUI

@main
struct SuitUpApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
