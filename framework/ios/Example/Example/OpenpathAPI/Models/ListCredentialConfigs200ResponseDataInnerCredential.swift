//
// ListCredentialConfigs200ResponseDataInnerCredential.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ListCredentialConfigs200ResponseDataInnerCredential: Codable, JSONEncodable, Hashable, QuestionChoice {
    public var id: Int
    public var startDate: Date?
    public var endDate: Date?
    public var credentialType: ListCredentialConfigs200ResponseDataInnerCredentialCredentialType
    public var mobile: ListCredentialConfigs200ResponseDataInnerCredentialMobile?
    public var eventAction: ListCredentialConfigs200ResponseDataInnerCredentialEventAction?
    public var pincode: ListCredentialConfigs200ResponseDataInnerCredentialPincode?
    public var card: ListCredentialConfigs200ResponseDataInnerCredentialCard?
    public var cardMifareCsn: ListCredentialConfigs200ResponseDataInnerCredentialPincode?
    public var cardOpenpathDesfireEv1: ListCredentialConfigs200ResponseDataInnerCredentialPincode?
    public var cloudKey: ListCredentialConfigs200ResponseDataInnerCredentialCloudKey?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var user: ListCredentialConfigs200ResponseDataInnerCredentialUser?
    public var badgeConfig: ListCredentialConfigs200ResponseDataInnerCredentialBadgeConfig?
    public var groupBadgeConfig: ListCredentialConfigs200ResponseDataInnerCredentialBadgeConfig?
    public var orgDefaultBadgeConfig: ListCredentialConfigs200ResponseDataInnerCredentialBadgeConfig?

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case startDate
        case endDate
        case credentialType
        case mobile
        case eventAction
        case pincode
        case card
        case cardMifareCsn
        case cardOpenpathDesfireEv1
        case cloudKey
        case createdAt
        case updatedAt
        case user
        case badgeConfig
        case groupBadgeConfig
        case orgDefaultBadgeConfig
    }

    public var description: String {
        mobile?.name ?? "<Credential #\(id)>"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(startDate, forKey: .startDate)
        try container.encodeIfPresent(endDate, forKey: .endDate)
        try container.encodeIfPresent(credentialType, forKey: .credentialType)
        try container.encodeIfPresent(mobile, forKey: .mobile)
        try container.encodeIfPresent(eventAction, forKey: .eventAction)
        try container.encodeIfPresent(pincode, forKey: .pincode)
        try container.encodeIfPresent(card, forKey: .card)
        try container.encodeIfPresent(cardMifareCsn, forKey: .cardMifareCsn)
        try container.encodeIfPresent(cardOpenpathDesfireEv1, forKey: .cardOpenpathDesfireEv1)
        try container.encodeIfPresent(cloudKey, forKey: .cloudKey)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encodeIfPresent(badgeConfig, forKey: .badgeConfig)
        try container.encodeIfPresent(groupBadgeConfig, forKey: .groupBadgeConfig)
        try container.encodeIfPresent(orgDefaultBadgeConfig, forKey: .orgDefaultBadgeConfig)
    }
}