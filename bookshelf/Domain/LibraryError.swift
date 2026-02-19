import Foundation

enum LibraryError: Error, LocalizedError, Identifiable {
    case save
    case load
    case delete
    case search
    case unknown

    var id: String { String(describing: self) }

    var errorDescription: String? {
        switch self {
        case .load: return "Не удалось загрузить книгу"
        case .save: return "Не удалось сохранить книгу"
        case .delete: return "Не удалость удалить книгу"
        case .search: return "Не удалось выполнить поиск по заданным фильтрам"
        case .unknown: return "Неизвестная ошибка"
        }
    }
}
