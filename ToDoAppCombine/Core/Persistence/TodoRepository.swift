//
//  TodoRepository.swift
//  ToDoAppCombine
//
//  Created by Alper Gok on 18.05.2025.
//

import CoreData
import Combine

protocol TodoRepositoryProtocol {
    func fetchTodos() -> AnyPublisher<[Todo], Error>
    func createTodo(title: String) -> AnyPublisher<Todo, Error>
    func updateTodo(_ todo: Todo, title: String) -> AnyPublisher<Todo, Error>
    func deleteTodo(_ todo: Todo) -> AnyPublisher<Void, Error>
    func toggleTodo(_ todo: Todo) -> AnyPublisher<Todo, Error>
}

final class TodoRepository: TodoRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceManager.shared.context) {
        self.context = context
    }
    
    func fetchTodos() -> AnyPublisher<[Todo], Error> {
        Future<[Todo], Error> { promise in
            let request: NSFetchRequest<Todo> = Todo.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Todo.createdAt, ascending: false)]
            
            do {
                let todos = try self.context.fetch(request)
                promise(.success(todos))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    
    func createTodo(title: String) -> AnyPublisher<Todo, Error> {
        Future<Todo, Error> { promise in
            let todo = Todo(context: self.context)
            todo.id = UUID()
            todo.title = title
            todo.createdAt = Date()
            todo.isCompleted = false
            
            do {
                try self.context.save()
                promise(.success(todo))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateTodo(_ todo: Todo, title: String) -> AnyPublisher<Todo, Error> {
        Future<Todo, Error> { promise in
            todo.title = title
            todo.updatedAt = Date()
            
            do {
                try self.context.save()
                promise(.success(todo))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteTodo(_ todo: Todo) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            self.context.delete(todo)
            
            do {
                try self.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func toggleTodo(_ todo: Todo) -> AnyPublisher<Todo, Error> {
        Future<Todo, Error> { promise in
            todo.isCompleted.toggle()

            
            do {
                try self.context.save()
                promise(.success(todo))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
} 
