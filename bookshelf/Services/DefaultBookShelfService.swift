import Foundation

final class DefaultBookShelfService: BookShelfService {

    private let repository: BookShelfRepository

    init(repository: BookShelfRepository) {
        self.repository = repository
    }

    func get(id: UUID) async throws -> Book? {
        try await repository.fetch(id: id)
    }

    func add(book: Book) async throws -> UUID {
        try await repository.add(book)
    }

    func delete(id: UUID) async throws {
        try await repository.delete(id: id)
    }

    func search(query: SearchQuery) async throws -> [Book] {
        try await repository.search(query: query)
    }

    func getAll() async throws -> [Book] {
        try await repository.fetchAll()
    }
}
