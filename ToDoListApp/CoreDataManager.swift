//
//  CoreDataManager.swift
//  ToDoListApp
//
//  Created by Alper Gok on 8.05.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoListApp")
        container.loadPersistentStores { description, error in
            if let error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // MARK: -  CRUD
    
    func createTodo(title: String) -> TodoItem {
        let todo = TodoItem(context: context)
        todo.id = UUID()
        todo.title = title
        todo.isCompleted = false
        todo.createdAt = Date()
        todo.createdAt = Date()
        saveContext()
        return todo
    }
    
    func fetchTodo() -> [TodoItem] {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TodoItem.createdAt, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching todos \(error)")
            return []
        }
        
    }
    
    func updateTodo(in todo: TodoItem, title: String? = nil, isCompleted: Bool? = nil) {
        if let title = title {
            todo.title = title
        }
        if let isCompleted = isCompleted {
            todo.isCompleted = isCompleted
        }
        todo.updateAt = Date()
        saveContext()
    }
    
    func deleteTodo(in todo: TodoItem) {
        context.delete(todo)
        saveContext()
    }
    
    
    
    
    
    
    
    
    
    
}
