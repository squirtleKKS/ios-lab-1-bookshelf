import Foundation

protocol BookShelfService: Sendable {
    func get(id: UUID) async throws -> Book?
    func add(book: Book) async throws -> UUID
    func delete(id: UUID) async throws
    func search(query: SearchQuery) async throws -> [Book]
    func getAll() async throws -> [Book]
}
