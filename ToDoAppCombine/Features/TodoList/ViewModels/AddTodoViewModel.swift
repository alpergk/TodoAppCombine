//
//  AddTodoViewModel.swift
//  ToDoAppCombine
//
//  Created by Alper Gok on 18.05.2025.
//

import Foundation
import Combine
import CoreData

final class AddTodoViewModel {
    // MARK: - Properties
    private let repository: TodoRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // Published properties for UI binding
    @Published private(set) var error: Error?
    @Published private(set) var isSaving = false
    
    // MARK: - Initialization
    init(repository: TodoRepositoryProtocol = TodoRepository()) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    func createTodo(title: String) -> AnyPublisher<Todo, Error> {
        isSaving = true
        
        return repository.createTodo(title: title)
            .receive(on: DispatchQueue.main)
            .handleEvents(
                receiveCompletion: { [weak self] completion in
                    self?.isSaving = false
                    if case .failure(let error) = completion {
                        self?.error = error
                    }
                }
            )
            .eraseToAnyPublisher()
    }
} 
