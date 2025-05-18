//
//  TodoError.swift
//  ToDoAppCombine
//
//  Created by Alper Gok on 18.05.2025.
//

import Foundation

enum TodoError: LocalizedError {
    case fetchError
    case createError
    case updateError
    case deleteError
    case toggleError
    case invalidTitle
    
    var errorDescription: String? {
        switch self {
        case .fetchError:
            return "Failed to fetch todos"
        case .createError:
            return "Failed to create todo"
        case .updateError:
            return "Failed to update todo"
        case .deleteError:
            return "Failed to delete todo"
        case .toggleError:
            return "Failed to toggle todo status"
        case .invalidTitle:
            return "Todo title cannot be empty"
        }
    }
} 
