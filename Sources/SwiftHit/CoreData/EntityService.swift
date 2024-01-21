//
//  EntityService.swift
//  app-starter
//
//  Created by hocgin on 2024/1/19.
//

import CoreData
import Foundation

public protocol DataEnvironment {
    var database: String { get }
}

public class DataContext {
    var environment: DataEnvironment
    var inMemory = false
    var container: NSPersistentContainer
    var viewContext: NSManagedObjectContext
    public init(env: DataEnvironment) {
        self.environment = env

        let name = self.environment.database
        self.container = NSPersistentContainer(name: name)

        if self.inMemory {
            self.container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        // 尝试加载数据
        self.container.loadPersistentStores { _, error in
            if let error = error as! NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.container.viewContext.automaticallyMergesChangesFromParent = true
        self.viewContext = self.container.viewContext
    }
}

public typealias EntityModel = NSManagedObject

extension EntityModel {
    static func getType() -> String {
        return String(describing: self)
    }

    public func save() {
        let viewCxt = self.managedObjectContext
        try? viewCxt?.save()
    }

    public func delete() {
        let viewCxt = self.managedObjectContext
        try? viewCxt?.delete(self)
    }
}


// https://itisjoe.gitbooks.io/swiftgo/content/database/coredata.html
public class EntityService<T: EntityModel> {
    var viewContext: NSManagedObjectContext

    public init(context: DataContext) {
        self.viewContext = context.viewContext
    }

    public func insertNewObject() -> T {
        let entityName = T.getType()
        return try! NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.viewContext) as! T
    }

    /**
     查询
      */
    public func selectList() -> [T] {
        let entityName = T.getType()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        return try! self.viewContext.fetch(request) as! [T]
    }
}
