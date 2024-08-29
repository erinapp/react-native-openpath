//
// ListCredentialConfigs200ResponseDataInnerCredentialUser.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ListCredentialConfigs200ResponseDataInnerCredentialUser: Codable, JSONEncodable, Hashable {
    public var id: Double?
    public var opal: String?
    public var status: String?
    public var startDate: Date?
    public var endDate: Date?
    public var hasRemoteUnlock: Bool?
    public var isOverrideAllowed: Bool?
    public var externalId: String?
    public var identity: ListCredentialConfigs200ResponseDataInnerCredentialUserIdentity?
    public var groups: [ListCredentialConfigs200ResponseDataInnerOrg]?
    public var userCustomFields: [ListCredentialConfigs200ResponseDataInnerCredentialUserUserCustomFieldsInner]?
    public var buildingFloorUnits: [ListCredentialConfigs200ResponseDataInnerCredentialUserBuildingFloorUnitsInner]?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var manuallyInactivatedAt: Date?
    public var lastActivityAt: Date?

    public init(
        id: Double? = nil,
        opal: String? = nil,
        status: String? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        hasRemoteUnlock: Bool? = nil,
        isOverrideAllowed: Bool? = nil,
        externalId: String? = nil,
        identity: ListCredentialConfigs200ResponseDataInnerCredentialUserIdentity? = nil,
        groups: [ListCredentialConfigs200ResponseDataInnerOrg]? = nil,
        userCustomFields: [ListCredentialConfigs200ResponseDataInnerCredentialUserUserCustomFieldsInner]? = nil,
        buildingFloorUnits: [ListCredentialConfigs200ResponseDataInnerCredentialUserBuildingFloorUnitsInner]? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        manuallyInactivatedAt: Date? = nil,
        lastActivityAt: Date? = nil
    ) {
        self.id = id
        self.opal = opal
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
        self.hasRemoteUnlock = hasRemoteUnlock
        self.isOverrideAllowed = isOverrideAllowed
        self.externalId = externalId
        self.identity = identity
        self.groups = groups
        self.userCustomFields = userCustomFields
        self.buildingFloorUnits = buildingFloorUnits
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.manuallyInactivatedAt = manuallyInactivatedAt
        self.lastActivityAt = lastActivityAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case opal
        case status
        case startDate
        case endDate
        case hasRemoteUnlock
        case isOverrideAllowed
        case externalId
        case identity
        case groups
        case userCustomFields
        case buildingFloorUnits
        case createdAt
        case updatedAt
        case manuallyInactivatedAt
        case lastActivityAt
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(opal, forKey: .opal)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(startDate, forKey: .startDate)
        try container.encodeIfPresent(endDate, forKey: .endDate)
        try container.encodeIfPresent(hasRemoteUnlock, forKey: .hasRemoteUnlock)
        try container.encodeIfPresent(isOverrideAllowed, forKey: .isOverrideAllowed)
        try container.encodeIfPresent(externalId, forKey: .externalId)
        try container.encodeIfPresent(identity, forKey: .identity)
        try container.encodeIfPresent(groups, forKey: .groups)
        try container.encodeIfPresent(userCustomFields, forKey: .userCustomFields)
        try container.encodeIfPresent(buildingFloorUnits, forKey: .buildingFloorUnits)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(manuallyInactivatedAt, forKey: .manuallyInactivatedAt)
        try container.encodeIfPresent(lastActivityAt, forKey: .lastActivityAt)
    }
}
