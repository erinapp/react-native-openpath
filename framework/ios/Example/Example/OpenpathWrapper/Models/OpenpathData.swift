import Foundation

final class OpenpathData: ObservableObject {
    // swiftformat:sort
    struct Item: Decodable, CustomStringConvertible, Equatable, Hashable {
        var acuId: Int
        var cameraIds: [Int]
        var color: String
        var description: String {
            "<\(itemType): \(name): \(itemId), \(isInRange)>"
        }

        var isAvailableInRange: Bool
        var isAvailableNearbyNotification: Bool
        var isAvailableOverrideUnlock: Bool
        var isInRange: Bool
        var itemId: Int
        var itemType: ItemType
        var name: String
        var orgName: String
        var readerIds: [Int]
    }

    // swiftformat:sort
    struct Camera: Decodable {
        var id: Int
        var idExt: String? // the external id in the video provider system
        var name: String
        var nameExt: String // the external name in the video provider system
        var supportsIntercom: Bool
        var timeZoneId: String?

        var videoProviderId: Int
    }

    // swiftformat:sort
    struct ItemOrdering: Decodable {
        var itemId: Int
        var itemType: ItemType
        var keyIdType: String { "\(itemType)-\(itemId)" }
    }

    // swiftformat:sort
    struct ItemState: Decodable {
        var isScheduledAvailableRevert: Bool?
        var isScheduledNoAccess: Bool?
        var isScheduledOverrideAllowed: Bool?
        var isScheduledRemoteUnlockAllowed: Bool?
        var isScheduledTouchAllowed: Bool?
        var isScheduledUnlocked: Bool?
        var itemId: Int
        var itemType: ItemType
    }

    struct ItemsSet: Decodable {
        var items: [String: Item]
        var itemOrdering: [ItemOrdering]
    }

    struct ItemsUpdate: Decodable {
        var items: [String: Item]?
        var cameras: [Camera]?
    }

    struct ItemStates: Decodable {
        var itemStates: [String: ItemState]
    }

    // swiftformat:sort
    struct ReaderInRange: Decodable {
        var avgBleRssi: Int
        var id: Int
        var keyIdType: String { "reader-\(id)" }
        var name: String
    }

    @Published var onHold: Bool = false
    @Published var isUnlockResponse: Bool = false
    @Published var items = [String: Item]()
    @Published var itemOrdering = [ItemOrdering]()
    @Published var itemStates = [String: ItemState]()
    @Published var readerRssiThreshold: Double = 7.0
    @Published var readersInRange = [ReaderInRange]()
}

extension OpenpathData.Item {
    static func forPreview() -> OpenpathData.Item {
        return .init(acuId: 1,
                     cameraIds: [],
                     color: "",
                     isAvailableInRange: true,
                     isAvailableNearbyNotification: true,
                     isAvailableOverrideUnlock: true,
                     isInRange: true,
                     itemId: 1,
                     itemType: ItemType.reader,
                     name: "demo item",
                     orgName: "org:demo",
                     readerIds: [])
    }
}
