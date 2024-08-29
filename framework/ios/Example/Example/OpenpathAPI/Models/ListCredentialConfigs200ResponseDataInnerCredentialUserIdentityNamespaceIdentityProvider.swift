//
// ListCredentialConfigs200ResponseDataInnerCredentialUserIdentityNamespaceIdentityProvider.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ListCredentialConfigs200ResponseDataInnerCredentialUserIdentityNamespaceIdentityProvider: Codable,
    JSONEncodable, Hashable {
    public var id: Double?
    public var identityProviderType: ListCredentialConfigs200ResponseDataInnerOrg?
    public var org: ListCredentialConfigs200ResponseDataInnerOrg?

    public init(
        id: Double? = nil,
        identityProviderType: ListCredentialConfigs200ResponseDataInnerOrg? = nil,
        org: ListCredentialConfigs200ResponseDataInnerOrg? = nil
    ) {
        self.id = id
        self.identityProviderType = identityProviderType
        self.org = org
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case identityProviderType
        case org
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(identityProviderType, forKey: .identityProviderType)
        try container.encodeIfPresent(org, forKey: .org)
    }
}