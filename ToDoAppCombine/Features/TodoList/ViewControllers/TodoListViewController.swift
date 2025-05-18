//
//  ToDoListViewController.swift
//  ToDoAppCombine
//
//  Created by Alper Gok on 18.05.2025.
//

import UIKit
import Combine

final class TodoListViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: TodoListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var todoListView: TodoListView = {
        let view = TodoListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    // MARK: - Initialization
    init(viewModel: TodoListViewModel = TodoListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindViewModel()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(todoListView)
        
        NSLayoutConstraint.activate([
            todoListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todoListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todoListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            todoListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Todos"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
    }
    
    private func bindViewModel() {
        // Bind todos
        viewModel.$todos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] todos in
                self?.todoListView.updateTodos(todos)
            }
            .store(in: &cancellables)
        
        // Bind loading state
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.todoListView.setLoading(isLoading)
            }
            .store(in: &cancellables)
        
        // Bind error state
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.showError(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        let alert = UIAlertController(
            title: "New Todo",
            message: "Enter a title for your todo",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Todo title"
            textField.autocapitalizationType = .sentences
            textField.clearButtonMode = .whileEditing
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let title = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !title.isEmpty else {
                self?.showError("Todo title cannot be empty")
                return
            }
            
            self?.viewModel.createTodo(title: title)
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Helpers
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - TodoListViewDelegate
extension TodoListViewController: TodoListViewDelegate {
    func didPullToRefresh() {
        viewModel.loadTodos()
    }
    
    func didSelectTodo(at index: Int) {
        let todo = viewModel.todos[index]
        viewModel.toggleTodo(todo)
    }
    
    func didSwipeToDelete(at index: Int) {
        let todo = viewModel.todos[index]
        viewModel.deleteTodo(todo)
    }
    
    func didSwipeToEdit(at index: Int) {
        let todo = viewModel.todos[index]
        showEditAlert(for: todo)
    }
    
    private func showEditAlert(for todo: Todo) {
        let alert = UIAlertController(
            title: "Edit Todo",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.text = todo.title
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let newTitle = alert.textFields?.first?.text else { return }
            self?.viewModel.updateTodo(todo, newTitle: newTitle)
        })
        
        present(alert, animated: true)
    }
} 
