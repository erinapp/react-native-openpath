//
// ListCredentialConfigs200ResponseDataInnerCredentialUserIdentity.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ListCredentialConfigs200ResponseDataInnerCredentialUserIdentity: Codable, JSONEncodable, Hashable {
    public var id: Double?
    public var opal: String?
    public var roles: [ListCredentialConfigs200ResponseDataInnerCredentialUserIdentityRolesInner]?
    public var mfaCredentials: [ListCredentialConfigs200ResponseDataInnerCredentialUserIdentityMfaCredentialsInner]?
    public var firstName: String?
    public var middleName: String?
    public var lastName: String?
    public var fullName: String?
    public var initials: String?
    public var email: String?
    public var isEmailVerified: Bool?
    public var namespace: ListCredentialConfigs200ResponseDataInnerCredentialUserIdentityNamespace?
    public var idpUniqueIdentifier: String?
    public var needsPasswordChange: Bool? = false
    public var createdAt: Date?
    public var updatedAt: Date?
    public var users: [ListCredentialConfigs200ResponseDataInnerCredentialUserIdentityUsersInner]?

    public init(
        id: Double? = nil,
        opal: String? = nil,
        roles: [ListCredentialConfigs200ResponseDataInnerCredentialUserIdentityRolesInner]? = nil,
        mfaCredentials: [ListCredentialConfigs200ResponseDataInnerCredentialUserIdentityMfaCredentialsInner]? = nil,
        firstName: String? = nil,
        middleName: String? = nil,
        lastName: String? = nil,
        fullName: String? = nil,
        initials: String? = nil,
        email: String? = nil,
        isEmailVerified: Bool? = nil,
        namespace: ListCredentialConfigs200ResponseDataInnerCredentialUserIdentityNamespace? = nil,
        idpUniqueIdentifier: String? = nil,
        needsPasswordChange: Bool? = false,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        users: [ListCredentialConfigs200ResponseDataInnerCredentialUserIdentityUsersInner]? = nil
    ) {
        self.id = id
        self.opal = opal
        self.roles = roles
        self.mfaCredentials = mfaCredentials
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.fullName = fullName
        self.initials = initials
        self.email = email
        self.isEmailVerified = isEmailVerified
        self.namespace = namespace
        self.idpUniqueIdentifier = idpUniqueIdentifier
        self.needsPasswordChange = needsPasswordChange
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.users = users
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case opal
        case roles
        case mfaCredentials
        case firstName
        case middleName
        case lastName
        case fullName
        case initials
        case email
        case isEmailVerified
        case namespace
        case idpUniqueIdentifier
        case needsPasswordChange
        case createdAt
        case updatedAt
        case users
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(opal, forKey: .opal)
        try container.encodeIfPresent(roles, forKey: .roles)
        try container.encodeIfPresent(mfaCredentials, forKey: .mfaCredentials)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(middleName, forKey: .middleName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(fullName, forKey: .fullName)
        try container.encodeIfPresent(initials, forKey: .initials)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(isEmailVerified, forKey: .isEmailVerified)
        try container.encodeIfPresent(namespace, forKey: .namespace)
        try container.encodeIfPresent(idpUniqueIdentifier, forKey: .idpUniqueIdentifier)
        try container.encodeIfPresent(needsPasswordChange, forKey: .needsPasswordChange)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(users, forKey: .users)
    }
}
