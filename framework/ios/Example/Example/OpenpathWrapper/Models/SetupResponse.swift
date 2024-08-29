struct SetupResponse: Decodable {
    let provisionResult: ProvisionResponse
    let switchUserResult: SwitchUserResponse
    let syncUserResult: SyncUserResponse
}
