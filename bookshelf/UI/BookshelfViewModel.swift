import SwiftUI
import Combine

@MainActor
final class BookshelfViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var isLoading = false
    @Published var error: LibraryError?

    @Published var searchTitle: String = ""
    @Published var searchAuthor: String = ""
    @Published var searchTag: String = ""
    @Published var selectedGenre: Genre? = nil
    @Published var searchYearText: String = ""
    

    private let service: BookShelfService

    init(service: BookShelfService) {
        self.service = service
    }

    func loadAll() async {
        isLoading = true
        defer { isLoading = false }

        do {
            books = try await service.getAll()
        } catch {
            self.error = .load
        }
    }

    func add(title: String, author: String, year: Int?, genre: Genre, tags: [String]) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let book = Book(title: title, author: author, publicationYear: year, genre: genre, tags: tags)
            _ = try await service.add(book: book)
            await refreshAfterChange()
        } catch {
            self.error = .save
        }
    }
    
    func delete(id: UUID) async {
        do {
            try await service.delete(id: id)
            books.removeAll { $0.id == id }
        } catch {
            self.error = .delete
        }
    }

    func applyFilters() async {
        let title = searchTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let author = searchAuthor.trimmingCharacters(in: .whitespacesAndNewlines)
        let tag = searchTag.trimmingCharacters(in: .whitespacesAndNewlines)
        let year = Int(searchYearText.trimmingCharacters(in: .whitespacesAndNewlines))

        if title.isEmpty, author.isEmpty, tag.isEmpty, selectedGenre == nil, year == nil {
            await loadAll()
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let query = SearchQuery(
                title: title.isEmpty ? nil : title,
                author: author.isEmpty ? nil : author,
                genre: selectedGenre,
                tag: tag.isEmpty ? nil : tag,
                year: year
            )
            books = try await service.search(query: query)
        } catch {
            self.error = .search
        }
    }

    func clearFilters() async {
        searchTitle = ""
        searchAuthor = ""
        searchTag = ""
        selectedGenre = nil
        searchYearText = ""
        await loadAll()
    }

    private func refreshAfterChange() async {
        let title = searchTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let author = searchAuthor.trimmingCharacters(in: .whitespacesAndNewlines)
        let tag = searchTag.trimmingCharacters(in: .whitespacesAndNewlines)
        let year = Int(searchYearText.trimmingCharacters(in: .whitespacesAndNewlines))

        if title.isEmpty, author.isEmpty, tag.isEmpty, selectedGenre == nil, year == nil {
            await loadAll()
        } else {
            await applyFilters()
        }
    }
}
