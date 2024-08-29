import SwiftUI

struct LoginProgressView: View {
    @EnvironmentObject private var viewModel: LoginViewModel

    var body: some View {
        if let busyMessage = viewModel.busyMessage {
            ProgressView(busyMessage + "…")
                .tint(Color.white)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.75))
        }
    }
}
