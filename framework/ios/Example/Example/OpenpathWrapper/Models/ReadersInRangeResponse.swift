import Foundation

struct ReaderInRange: Decodable {
    let id: Int
    let name: String
    let avgBleRssi: Int
}

struct ReadersInRangeResponse: Decodable {
    let readersInRange: [ReaderInRange]
}
