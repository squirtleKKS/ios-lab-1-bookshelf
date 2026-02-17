import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var author = ""
    @State private var yearText = ""
    @State private var genre: Genre = .fiction
    @State private var tagsText = ""
    private var trimmedYear: String {
        yearText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isYearValid: Bool {
        if trimmedYear.isEmpty { return true }
        guard let y = Int(trimmedYear) else { return false }
        return (1400...2026).contains(y)
    }
    let onSave: (_ title: String, _ author: String, _ year: Int?, _ genre: Genre, _ tags: [String]) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Основное") {
                    TextField("Название", text: $title)
                    TextField("Автор", text: $author)
                    TextField("Год", text: $yearText)
                        .keyboardType(.numberPad)
                    if !isYearValid {
                        Text("Введите год от 1400 до 2026 или оставьте пустым")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }

                    Picker("Жанр", selection: $genre) {
                        ForEach(Genre.allCases, id: \.self) { genre in
                            Text(genre.rawValue).tag(genre)
                        }
                    }
                }

                Section("Теги") {
                    TextField("classic, space", text: $tagsText)
                }
            }
            .navigationTitle("Добавить книгу")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        let year = Int(yearText.trimmingCharacters(in: .whitespacesAndNewlines))
                        let tags = tagsText
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                            .filter { !$0.isEmpty }

                        onSave(
                            title.trimmingCharacters(in: .whitespacesAndNewlines),
                            author.trimmingCharacters(in: .whitespacesAndNewlines),
                            year,
                            genre,
                            tags
                        )
                        dismiss()
                    }
                    .disabled(
                        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        !isYearValid
                    )
                }
            }
        }
    }
}
