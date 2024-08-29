import Foundation

struct ProvisionResponse: Decodable {
    let userOpal: String

    let environment: Environment
    struct Environment: Decodable {
        let heliumEndpoint: String
        let opalEnv: String
        let opalRegion: String
    }

    typealias User = OpenpathUser
    let user: User

    let credential: Credential
    struct Credential: Decodable {
        let id: Int
        let opal: String

        let credentialType: CredentialType
        struct CredentialType: Decodable {
            let modelName: String
        }

        let mobile: Mobile
        struct Mobile: Decodable {
            let id: Int
            let name: String
            let provisionedAt: String
        }
    }
}
