import Foundation

enum Genre: String, Codable, CaseIterable, Identifiable {
    case fiction
    case nonFiction
    case fantasy
    case sciFi
    case biography
    case history
    case other

    var id: String { rawValue }
}
