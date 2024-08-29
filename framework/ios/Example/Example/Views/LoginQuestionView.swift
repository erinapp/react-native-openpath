import SwiftUI

struct LoginQuestionView: View {
    @EnvironmentObject private var viewModel: LoginViewModel

    let question: String
    let choices: [QuestionChoice]
    let answer: (QuestionChoice) -> Void
    let cancel: () -> Void

    var body: some View {
        ZStack {
            VStack {
                Text(question)
                List(choices, id: \.id) { choice in
                    Button {
                        answer(choice)
                    } label: {
                        Text(choice.description)
                    }.padding()
                }
                Button("Cancel login", action: cancel).foregroundColor(.secondary)
                Spacer()
            }
            LoginProgressView()
        }
    }
}
