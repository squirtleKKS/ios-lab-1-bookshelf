import Foundation

actor InMemoryBookShelfRepository: BookShelfRepository {

    private var storage: [UUID: Book] = [:]

    func add(_ book: Book) async throws -> UUID {
        
        storage[book.id] = book
        return book.id
    }

    func delete(id: UUID) async throws {
        guard storage.removeValue(forKey: id) != nil else {
            throw BookError.notFound
        }
    }

    func fetch(id: UUID) async throws -> Book? {
        storage[id]
    }

    func fetchAll() async throws -> [Book] {
        Array(storage.values).sortedStable()
    }

    func search(query: SearchQuery) async throws -> [Book] {
        let results = storage.values.filter { book in

            if let title = query.title,
               !title.isEmpty,
               !book.title.containsNormalized(title) {
                return false
            }

            if let author = query.author,
               !author.isEmpty,
               !book.author.containsNormalized(author) {
                return false
            }

            if let genre = query.genre,
               book.genre != genre {
                return false
            }

            if let tag = query.tag,
               !tag.isEmpty,
               !book.tags.contains(where: { $0.equalsNormalized(tag) }) {
                return false
            }

            if let year = query.year,
               book.publicationYear != year {
                return false
            }

            return true
        }

        return Array(results).sortedStable()
    }
}
