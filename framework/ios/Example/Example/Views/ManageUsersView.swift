import SwiftUI

private struct UserTile: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    let user: OpenpathUser
    @Binding
    var unprovisioning: OpenpathUser?

    var body: some View {
        HStack {
            if let url = user.pictureUrl {
                AsyncImage(url: URL(string: url)) { image in
                    image.resizable()
                } placeholder: {
                    EmptyView()
                }
            }
            VStack {
                VStack {
                    Text(user.org.name)
                    Text(user.identity.email)
                        .lineLimit(0)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }.onTapGesture {
                    loginViewModel.switchTo(user: user)
                }
                Divider()
                Group {
                    HStack {
                        Image(systemName: "person.fill.badge.minus")
                        Text("Remove account")
                    }.foregroundColor(Color(UIColor.systemRed))
                }.onTapGesture {
                    unprovisioning = user
                }
            }.multilineTextAlignment(.leading)
        }
    }
}

struct ManageUsersView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State var unprovisioning: OpenpathUser?

    var body: some View {
        if let activeUser = loginViewModel.provisionedUsers.first {
            let inactiveUsers = loginViewModel.provisionedUsers.dropFirst()

            let showingAlert = Binding<Bool>(get: { unprovisioning != nil }, set: { _ in unprovisioning = nil })

            ZStack {
                VStack {
                    List {
                        Section {
                            UserTile(user: activeUser, unprovisioning: $unprovisioning)
                        } header: {
                            Text("Active")
                        }
                        Section {
                            ForEach(inactiveUsers, id: \.id) { user in
                                UserTile(user: user, unprovisioning: $unprovisioning)
                            }
                        } header: {
                            Text("Inactive")
                        }
                    }
                    NavigationLink {
                        AddAccountView()
                    } label: {
                        HStack {
                            Image(systemName: "person.fill.badge.plus")
                            Text("Add account")
                        }
                    }
                    .listStyle(.insetGrouped)
                }
                LoginProgressView()
            }
            .alert("Unprovision \(unprovisioning?.uiLabel ?? "")?", isPresented: showingAlert) {
                if let unprovisioning {
                    Button("Unprovision", role: .destructive) {
                        loginViewModel.unprovision(userOpal: unprovisioning.opal)
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .navigationTitle("Manage Users")
        } else {
            // No logged-in users. This can happen in a transient situation after logging out while unwinding the
            // navigation stack
            EmptyView()
        }
    }
}

struct ManageUsersView_Previews: PreviewProvider {
    static var previews: some View {
        ManageUsersView().environmentObject(LoginViewModel())
    }
}
