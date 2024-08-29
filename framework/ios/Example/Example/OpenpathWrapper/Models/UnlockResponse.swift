import Foundation

struct UnlockResponse: Codable, CustomDebugStringConvertible {
    var debugDescription: String {
        let encoder = JSONEncoder()
        return String(data: try! encoder.encode(self), encoding: .utf8)!
    }

    let requestId: Int
    let status: Int
    let intCode: Int?
    let result: String?
    let description: String?
    let tip: String?
    let localizedTip: String?
    let moreInformationLink: String?
    let itemId: Int?
    let itemType: String?
}
