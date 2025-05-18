//
//  TodoListViewModel.swift
//  ToDoAppCombine
//
//  Created by Alper Gok on 18.05.2025.
//

import Foundation
import Combine
import CoreData

final class TodoListViewModel {
    // MARK: - Properties
    private let repository: TodoRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // Published properties for UI binding
    @Published private(set) var todos: [Todo] = []
    @Published private(set) var error: TodoError?
    @Published private(set) var isLoading = false
    
    // MARK: - Initialization
    init(repository: TodoRepositoryProtocol = TodoRepository()) {
        self.repository = repository
        loadTodos()
    }
    
    // MARK: - Public Methods
    func loadTodos() {
        isLoading = true
        error = nil
        
        repository.fetchTodos()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error as? TodoError ?? .fetchError
                    }
                },
                receiveValue: { [weak self] todos in
                    self?.todos = todos
                }
            )
            .store(in: &cancellables)
    }
    
    func toggleTodo(_ todo: Todo) {
        error = nil
        
        repository.toggleTodo(todo)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error as? TodoError ?? .toggleError
                    }
                },
                receiveValue: { [weak self] _ in
                    self?.loadTodos()
                }
            )
            .store(in: &cancellables)
    }
    
    func deleteTodo(_ todo: Todo) {
        error = nil
        
        repository.deleteTodo(todo)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error as? TodoError ?? .deleteError
                    }
                },
                receiveValue: { [weak self] _ in
                    self?.loadTodos()
                }
            )
            .store(in: &cancellables)
    }
    
    func updateTodo(_ todo: Todo, newTitle: String) {
        guard !newTitle.isEmpty else {
            error = .invalidTitle
            return
        }
        
        error = nil
        
        repository.updateTodo(todo, title: newTitle)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error as? TodoError ?? .updateError
                    }
                },
                receiveValue: { [weak self] _ in
                    self?.loadTodos()
                }
            )
            .store(in: &cancellables)
    }
    
    func createTodo(title: String) {
        error = nil
        
        repository.createTodo(title: title)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error as? TodoError ?? .createError
                    }
                },
                receiveValue: { [weak self] _ in
                    self?.loadTodos()  // Reload to get updated list
                }
            )
            .store(in: &cancellables)
    }
} 
