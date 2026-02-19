import Foundation

struct SearchQuery: Sendable {
    var title: String?
    var author: String?
    var genre: Genre?
    var tag: String?
    var year: Int?

    init(
        title: String? = nil,
        author: String? = nil,
        genre: Genre? = nil,
        tag: String? = nil,
        year: Int? = nil
    ) {
        self.title = title
        self.author = author
        self.genre = genre
        self.tag = tag
        self.year = year
    }
}
