import Foundation

extension String {
    nonisolated var normalized: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
    }

    nonisolated func containsNormalized(_ other: String) -> Bool {
        normalized.contains(other.normalized)
    }

    nonisolated func equalsNormalized(_ other: String) -> Bool {
        normalized == other.normalized
    }
}

extension Array where Element == Book {
    nonisolated func sortedStable() -> [Book] {
        sorted {
            let t0 = $0.title.normalized
            let t1 = $1.title.normalized
            if t0 != t1 { return t0 < t1 }

            let a0 = $0.author.normalized
            let a1 = $1.author.normalized
            if a0 != a1 { return a0 < a1 }

            return $0.id.uuidString < $1.id.uuidString
        }
    }
}
