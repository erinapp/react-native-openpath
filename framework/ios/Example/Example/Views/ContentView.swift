import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel

    var body: some View {
        switch loginViewModel.loginState {
        case .loggedOut:
            LoginView()

        case let .question(question: question, choices: choices, answer: answer, cancel: cancel):
            LoginQuestionView(question: question, choices: choices, answer: answer, cancel: cancel)

        case let .loggedIn(user):
            ItemListsView(user: user)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
