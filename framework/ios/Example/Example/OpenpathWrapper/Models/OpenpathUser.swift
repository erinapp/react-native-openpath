struct OpenpathUser: Codable, Equatable {
    let id: Int
    let opal: String
    let pictureUrl: String?

    let identity: Identity
    struct Identity: Codable, Equatable {
        let id: Int
        let opal: String
        let firstName: String?
        let middleName: String?
        let lastName: String?
        let email: String
    }

    let org: Org
    struct Org: Codable, Equatable {
        let id: Int
        let opal: String
        let name: String
        let pictureUrl: String?
    }

    var uiLabel: String {
        if identity.firstName != nil {
            return [identity.firstName, identity.middleName, identity.lastName].compactMap { $0 }.joined(separator: " ")
        }
        return identity.email
    }
}
