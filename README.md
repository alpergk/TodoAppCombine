# ToDoAppCombine

A modern, MVVM-architected iOS Todo app built with UIKit, Core Data, and Combine.
Features programmatic UI, reactive data flow, and best practices for scalable iOS development.

---

## Features

- Add, edit, delete, and complete todos
- Persistent storage with Core Data
- Reactive UI updates with Combine
- MVVM architecture
- Programmatic UIKit (no Storyboards)
- Dark mode & dynamic type support

---

## Architecture Overview

- **MVVM**: Clear separation of View, ViewModel, and Model
- **Repository Pattern**: Abstracts Core Data operations
- **Combine**: Handles all data flow and UI updates reactively

---

## Tech Stack

- **Swift** (latest)
- **UIKit** (programmatic)
- **Combine**
- **Core Data**

---

## Directory Structure

```
ToDoAppCombine/
├── App/                # AppDelegate, SceneDelegate
├── Core/               # PersistenceManager, TodoRepository, Entities
├── Features/           # Feature modules (e.g., TodoList -> Controller, ViewModels, Views)
├── ToDoAppCombine.xcdatamodeld
├── Assets.xcassets
├── Info.plist
```

---

## Combine Data Flow

**Example: Editing a Todo**

```
User taps "Edit" on a todo
    │
    ▼
TodoListViewController
    │
    ▼
showEditAlert(for: todo)
    │
    ▼
viewModel.updateTodo(todo, newTitle: newTitle)
    │
    ▼
TodoListViewModel
    │
    ▼
repository.updateTodo(todo, title: newTitle)
    │
    ▼
TodoRepository (updates Core Data, sets updatedAt)
    │
    ▼
Publishes updated todo via Combine
    │
    ▼
ViewModel receives publisher, calls loadTodos()
    │
    ▼
repository.fetchTodos() → publishes new todos array
    │
    ▼
ViewModel updates @Published var todos
    │
    ▼
ViewController observes todos, updates UI automatically
```

---

## How to Run

1. Clone the repo:
   ```sh
   git clone https://github.com/alpergk/TodoAppCombine.git
   ```
2. Open `ToDoAppCombine.xcodeproj` in Xcode.
3. Build and run on Simulator or device.

---

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## License

[MIT](LICENSE) 
