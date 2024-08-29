import SwiftUI

/**
 * List of items
 *
 * Tapping the main part of the item sends an unlock request.
 * Tapping the info button shows more information about the item.
 */
private struct ItemList: View {
    let title: String
    let items: [OpenpathData.Item]
    let iconName: String
    let iconTint: Color
    let onTapped: (OpenpathData.Item) -> Void

    @State var busyItems = Set<Int>()
    @State var errorMessages = [Int: String]()

    var body: some View {
        Section {
            if items.isEmpty {
                Text("No items").foregroundColor(.secondary).padding()
            } else {
                ForEach(items, id: \.itemId) { item in
                    HStack {
                        Button {
                            Task {
                                errorMessages[item.itemId] = nil
                                busyItems.insert(item.itemId)
                                defer {
                                    busyItems.remove(item.itemId)
                                }
                                do {
                                    let result = try await OpenpathWrapper.shared.unlock(
                                        itemType: item.itemType,
                                        itemId: item.itemId
                                    )
                                    appLog.debug("Unlock result \(result.debugDescription, privacy: .private)")

                                    // Result status is an HTTP code
                                    if result.status < 200 || result.status > 299 {
                                        throw OpenpathErrorMessageAndCode(
                                            message: result.description ?? result.result ?? "Error unlocking",
                                            code: result.status.description
                                        )
                                    }
                                } catch {
                                    // NOTE: In a customer-facing app, you should sanitize errors and present something localized and user-friendly
                                    errorMessages[item.itemId] = error.localizedDescription
                                }
                            }
                        } label: {
                            VStack {
                                HStack {
                                    Image(systemName: iconName).tint(iconTint)
                                    if busyItems.contains(item.itemId) {
                                        ProgressView().padding(.trailing)
                                    }
                                    Text(item.name).frame(maxWidth: .infinity, alignment: .leading)
                                }
                                if let errorMessage = errorMessages[item.itemId] {
                                    HStack {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .tint(SwiftUI.Color(UIColor.systemRed))
                                            .padding(.trailing)
                                        Text(errorMessage)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .foregroundColor(Color(UIColor.systemRed))
                                            .font(.system(size: 12))
                                            .multilineTextAlignment(.leading)
                                    }.padding(.top, 20)
                                }
                            }
                        }
                        .buttonStyle(.borderless)
                        .padding()
                        .frame(maxWidth: .infinity)

                        Button {
                            onTapped(item)
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .buttonStyle(.borderless)
                        .frame(alignment: .trailing)
                        .padding()
                    }
                }
            }
        } header: {
            Text(title).padding()
        }.onAppear {
            errorMessages.removeAll()
            busyItems.removeAll()
        }
    }
}

/**
 * View that shows all items the user can access.
 *
 * Note that in many apps you will only want to show those items that are in range. Refer also to the `getReadersInRange`
 * SDK function, which this does not use.
 */
struct ItemListsView: View {
    @State var selectedItemId: Int?
    @State private var path: [OpenpathData.Item] = []
    @StateObject var openpathData = OpenpathWrapper.shared.openpathData
    let user: OpenpathUser

    var body: some View {
        let items = Array(openpathData.items.values)
        let itemsInRange = items.filter(\.isInRange)
        let itemsOutOfRange = items.filter { !$0.isInRange }

        return NavigationStack(path: $path) {
            VStack {
                ForEach(items, id: \.itemId) { item in
                    NavigationLink(value: item) {
                        EmptyView()
                    }
                }
                List {
                    ItemList(
                        title: "In Range",
                        items: itemsInRange,
                        iconName: "antenna.radiowaves.left.and.right",
                        iconTint: Color.green,
                        onTapped: { path.append($0) }
                    )
                    ItemList(
                        title: "Out of Range",
                        items: itemsOutOfRange,
                        iconName: "antenna.radiowaves.left.and.right.slash",
                        iconTint: Color.gray,
                        onTapped: { path.append($0) }
                    )
                }
                .listStyle(.insetGrouped)
            }
            .navigationDestination(for: OpenpathData.Item.self, destination: { item in
                ItemDetailView(item: item)
            })
            .refreshable {
                OpenpathWrapper.shared.softRefresh()
                try? await Task.sleep(nanoseconds: 3 * 1000 * 1000)
            }
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.principal) {
                    VStack {
                        Text(user.org.name).bold()
                        Text(user.uiLabel)
                    }
                }
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    NavigationLink(destination: ManageUsersView()) {
                        Image(systemName: "person.circle")
                            .padding()
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}

struct ItemLists_Previews: PreviewProvider {
    static var previews: some View {
        let openpathData = OpenpathData()
        openpathData.items = [
            "item1": OpenpathData.Item(acuId: 1,
                                       cameraIds: [],
                                       color: "blue",
                                       isAvailableInRange: true,
                                       isAvailableNearbyNotification: true,
                                       isAvailableOverrideUnlock: true,
                                       isInRange: true,
                                       itemId: 1,
                                       itemType: .entry,
                                       name: "happy entry",
                                       orgName: "Happy Org",
                                       readerIds: [1, 2]),
            "item2": OpenpathData.Item(acuId: 2,
                                       cameraIds: [],
                                       color: "blue",
                                       isAvailableInRange: true,
                                       isAvailableNearbyNotification: true,
                                       isAvailableOverrideUnlock: true,
                                       isInRange: false,
                                       itemId: 2,
                                       itemType: .entry,
                                       name: "sad entry",
                                       orgName: "Happy Org",
                                       readerIds: [1, 2])
        ]
        return ItemListsView(openpathData: openpathData, user: OpenpathUser(id: 1,
                                                                            opal: "test",
                                                                            pictureUrl: nil,
                                                                            identity: OpenpathUser.Identity(id: 1,
                                                                                                            opal: "test",
                                                                                                            firstName: "Test",
                                                                                                            middleName: nil,
                                                                                                            lastName: "User",
                                                                                                            email: "test@example.com"),
                                                                            org: OpenpathUser.Org(id: 1,
                                                                                                  opal: "org",
                                                                                                  name: "Org",
                                                                                                  pictureUrl: nil)))
    }
}
