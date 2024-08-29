import OpenpathMobile

extension AuthorizationStatusType: Decodable {}

enum AuthType: String, CaseIterable, Decodable {
    case location
    case motion
    case bluetooth
    case notification
    case microphone
}

struct AuthorizationStatus: Decodable {
    let authType: AuthType
    let status: AuthorizationStatusType
}
