import SwiftUI

struct DetailLine: View {
    let title: String
    let value: CustomStringConvertible

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
                .bold()
                .padding()
            Spacer()
            Text(value.description)
                .padding()
        }
    }
}

private struct ItemDetailViewInternal: View {
    let item: OpenpathData.Item
    let itemState: ItemState?
    let errorMessage: String?
    let onRefresh: () -> Void

    var body: some View {
        VStack {
            if let errorMessage {
                Text(errorMessage).bold().foregroundColor(Color(uiColor: UIColor.systemRed))
            } else if let itemState {
                List {
                    DetailLine(title: "itemType",
                               value: itemState.itemType)
                    DetailLine(title: "itemId",
                               value: itemState.itemId)
                    DetailLine(title: "isScheduledRemoteUnlockAllowed",
                               value: itemState.isScheduledRemoteUnlockAllowed)
                    DetailLine(title: "isScheduledAvailableRevert",
                               value: itemState.isScheduledAvailableRevert)
                    DetailLine(title: "isScheduledNoAccess",
                               value: itemState.isScheduledNoAccess)
                    DetailLine(title: "isScheduledTouchAllowed",
                               value: itemState.isScheduledTouchAllowed)
                    DetailLine(title: "isScheduledUnlocked",
                               value: itemState.isScheduledUnlocked)
                    DetailLine(title: "isScheduledOverrideAllowed",
                               value: itemState.isScheduledOverrideAllowed)
                    Button {
                        Task {
                            try? await OpenpathWrapper.shared._unlockSpecial(itemType: item.itemType,
                                                                             itemId: item.itemId,
                                                                             connectionType: .ble)
                        }
                    } label: {
                        Text("BLE Unlock")
                    }
                }
            } else {
                ProgressView("Loading")
            }
        }.refreshable {
            onRefresh()
        }
    }
}

struct ItemDetailView: View {
    let item: OpenpathData.Item

    @State var itemState: ItemState?
    @State var errorMessage: String?

    var body: some View {
        let refresh: () -> Void = {
            Task {
                do {
                    itemState = try await OpenpathWrapper.shared.refreshItemState(
                        itemType: item.itemType,
                        itemId: item.itemId
                    )
                } catch {
                    errorMessage = "Failed to get item details"
                }
            }
        }

        ItemDetailViewInternal(item: item, itemState: itemState, errorMessage: errorMessage, onRefresh: refresh)
            .onAppear {
                refresh()
            }
            .navigationTitle(item.name)
    }
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailViewInternal(item: OpenpathData.Item.forPreview(),
                               itemState: ItemState(isScheduledRemoteUnlockAllowed: true,
                                                    isScheduledAvailableRevert: false,
                                                    itemType: .entry,
                                                    itemId: 2,
                                                    isScheduledNoAccess: false,
                                                    isScheduledTouchAllowed: true,
                                                    isScheduledUnlocked: false,
                                                    isScheduledOverrideAllowed: true),
                               errorMessage: nil, onRefresh: {})
    }
}
