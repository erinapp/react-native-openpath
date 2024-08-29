import Foundation

struct SyncUserResponse: Codable, CustomStringConvertible {
    let user: User
    typealias User = OpenpathUser
    let appVersion: AppVersion?
    struct AppVersion: Codable {
        let id: Int
        let latestBuild: Int
        let latestVersion: String
        let deprecatedBuild: Int
        let deprecatedVersion: String
        let latestSdkVersion: String
        let deprecatedSdkVersion: String
        let os: String
        let isUpdateRequired: Bool
    }

    var description: String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        return try! jsonEncoder.encode(self).description
    }
}
