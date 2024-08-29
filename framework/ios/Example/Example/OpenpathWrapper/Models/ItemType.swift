enum ItemType: String, Decodable, CustomStringConvertible {
    var description: String { rawValue }

    case entry
    case reader
}
