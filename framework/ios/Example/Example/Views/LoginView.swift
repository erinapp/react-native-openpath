import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var viewModel: LoginViewModel

    var body: some View {
        ZStack {
            VStack {
                Text(viewModel.loginViewHeader)
                    .bold()
                    .padding()
                    .padding([.bottom], 50)

                switch viewModel.loginMethod {
                case .email:
                    TextField("Email", text: $viewModel.email)
                        .cornerRadius(20)
                        .textFieldStyle(.roundedBorder)
                        .padding([.leading, .trailing], 28)
                        .keyboardType(.emailAddress)
                        .textContentType(.username)
                        .autocapitalization(.none)

                    SecureField("Password", text: $viewModel.password)
                        .cornerRadius(20)
                        .textFieldStyle(.roundedBorder)
                        .padding([.leading, .trailing], 28)
                        .textContentType(.password)

                    TextField("2fa (optional)", text: $viewModel.multifactor)
                        .cornerRadius(20)
                        .textFieldStyle(.roundedBorder)
                        .padding([.leading, .trailing], 28)
                        .textContentType(.oneTimeCode)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                case .token:
                    TextField("Setup Mobile Token", text: $viewModel.setupMobileToken)
                        .cornerRadius(20)
                        .textFieldStyle(.roundedBorder)
                        .padding([.leading, .trailing], 28)
                        .textContentType(.oneTimeCode)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                LoginErrorView()

                Button(viewModel.toggleButtonLabel) {
                    viewModel.loginMethod.toggle()
                }

                Button(viewModel.loginButtonLabel) {
                    viewModel.login()
                }
                .disabled(!viewModel.canLogin)
                .padding()
                .cornerRadius(20)
                .buttonBorderShape(.capsule)
                .buttonStyle(.bordered)

                Text(viewModel.sdkVersion)
            }
            .padding()
            .onSubmit {
                viewModel.login()
            }
            LoginProgressView()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: UIColor.systemBackground))
    }
}

struct LoginView_Previews: PreviewProvider {
    private static var loginViewModel = LoginViewModel()

    static var previews: some View {
        LoginView().environmentObject(loginViewModel)
    }
}
