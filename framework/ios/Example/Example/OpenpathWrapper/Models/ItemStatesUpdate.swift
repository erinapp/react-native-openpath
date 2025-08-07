struct ItemState: Decodable {
    let isScheduledRemoteUnlockAllowed: Bool?
    let isScheduledAvailableRevert: Bool?
    let itemType: ItemType
    let itemId: Int
    let isScheduledNoAccess: Bool?
    let isScheduledTouchAllowed: Bool?
    let isScheduledUnlocked: Bool?
    let isScheduledOverrideAllowed: Bool?
}

struct ItemStatesUpdate: Decodable {
    let itemStates: [String: ItemState]
}
