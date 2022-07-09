//
//  ExampleApp.swift
//  Example
//
//  Created by hocgin on 2022/7/9.
//

import SwiftUI
import SwiftHit

@main
struct ExampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    init() {
        print(SwiftHit.text)
    }
}
