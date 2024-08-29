struct UnprovisionResponse: Decodable {
    let userOpal: String?
    let reasonCode: Int
    let reasonDescription: String
}
