import SwiftUI

struct AddAccountView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel

    var body: some View {
        switch loginViewModel.loginState {
        case .loggedOut:
            fatalError("Unexpected login state")

        case let .question(question: question, choices: choices, answer: answer, cancel: cancel):
            LoginQuestionView(question: question, choices: choices, answer: answer, cancel: cancel)

        case .loggedIn:
            LoginView()
        }
    }
}

struct AddAccountView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountView()
    }
}
