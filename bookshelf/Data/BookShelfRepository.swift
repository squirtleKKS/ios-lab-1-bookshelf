import Foundation

protocol BookShelfRepository: Sendable {
    func add(_ book: Book) async throws -> UUID
    func delete(id: UUID) async throws
    func fetch(id: UUID) async throws -> Book?
    func fetchAll() async throws -> [Book]
    func search(query: SearchQuery) async throws -> [Book]
}
