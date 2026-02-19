import SwiftUI

struct BookshelfView: View {
    @StateObject private var vm: BookshelfViewModel
    @State private var isPresentingAdd = false
    @State private var isPresentingFilters = false

    init(service: BookShelfService) {
        _vm = StateObject(wrappedValue: BookshelfViewModel(service: service))
    }

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading && vm.books.isEmpty {
                    ProgressView()
                } else if vm.books.isEmpty {
                    ContentUnavailableView("Нет книг", systemImage: "books.vertical")
                } else {
                    List {
                        ForEach(vm.books) { book in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(book.title).font(.headline)
                                Text(book.author).foregroundStyle(.secondary)
                                HStack(spacing: 8) {
                                    Text(book.genre.rawValue)
                                    if let year = book.publicationYear {
                                        Text("\(year)")
                                    }
                                    if !book.tags.isEmpty {
                                        Text("\(book.tags.joined(separator: ", "))")
                                    }
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }.swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    Task { await vm.delete(id: book.id) }
                                } label: {
                                    Label("Удалить", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Books")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Все") { Task { await vm.clearFilters() } }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            isPresentingFilters = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                        Button {
                            isPresentingAdd = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .task { await vm.loadAll() }
            .sheet(isPresented: $isPresentingAdd) {
                AddBookView { title, author, year, genre, tags in
                    Task { await vm.add(title: title, author: author, year: year, genre: genre, tags: tags) }
                }
            }
            .sheet(isPresented: $isPresentingFilters) {
                FilterSheetView(vm: vm)
            }
            .alert(item: $vm.error) { error in
                Alert(
                    title: Text("Ошибка"),
                    message: Text(error.errorDescription ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
