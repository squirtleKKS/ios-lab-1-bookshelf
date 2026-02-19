import SwiftUI

@main
struct bookshelfApp: App {
    private let service: BookShelfService =
        DefaultBookShelfService(
            repository: InMemoryBookShelfRepository()
        )

    var body: some Scene {
        WindowGroup {
            BookshelfView(service: service)
        }
    }
}
