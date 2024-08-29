import Foundation

struct OpenpathErrorMessageAndCode: Error, Decodable {
    let message: String
    let code: String?
}

extension OpenpathErrorMessageAndCode {
    init(message: String) {
        self.init(message: message, code: nil)
    }
}

extension OpenpathErrorMessageAndCode: LocalizedError {
    var errorDescription: String? {
        if let code {
            return "\(code): \(message)"
        }
        return message
    }
}

struct OpenpathLoginCanceledError: Error, Decodable, LocalizedError {
    var errorDescription: String? {
        "Login canceled"
    }
}
