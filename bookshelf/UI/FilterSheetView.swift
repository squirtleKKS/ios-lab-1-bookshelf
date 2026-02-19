import SwiftUI

struct FilterSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: BookshelfViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Фильтры") {
                    TextField("Название", text: $vm.searchTitle)
                    TextField("Автор", text: $vm.searchAuthor)
                    TextField("Тег", text: $vm.searchTag)
                    TextField("Год", text: $vm.searchYearText)
                        .keyboardType(.numberPad)

                    Picker("Жанр", selection: $vm.selectedGenre) {
                        Text("Любой").tag(Genre?.none)
                        ForEach(Genre.allCases, id: \.self) { genre in
                            Text(genre.rawValue).tag(Optional(genre))
                        }
                    }
                }
            }
            .navigationTitle("Поиск")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Применить") {
                        Task { await vm.applyFilters() }
                        dismiss()
                    }
                }
            }
        }
    }
}
