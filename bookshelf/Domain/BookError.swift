import Foundation

enum BookError: Error, LocalizedError {
    case notFound
    var errorDescription: String?{
        switch self {
            case .notFound: "Книга не найдена"
        }
    }
}
