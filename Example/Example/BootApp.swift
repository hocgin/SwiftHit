//
//  ExampleApp.swift
//  Example
//
//  Created by hocgin on 2022/7/9.
//

import SwiftUI
import SwiftHit
import CoreHit
import UIHit

@main
struct BootApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationHitView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    init() {
        print(SwiftHit.text)
        print(CoreHit.text)
        print(UIHit.text)
    }
}
