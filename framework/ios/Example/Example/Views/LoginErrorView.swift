import SwiftUI

struct LoginErrorView: View {
    @EnvironmentObject private var viewModel: LoginViewModel

    var body: some View {
        if let errorMessage = viewModel.errorMessage {
            // NOTE: For development, we show full error information.
            // In a shipping app, you should limit this information.
            Text(errorMessage)
                .padding()
                .foregroundColor(Color(uiColor: .systemRed))
        } else {
            EmptyView()
        }
    }
}
