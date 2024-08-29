//
// GlobalListAcus200ResponseDataInner.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct GlobalListAcus200ResponseDataInner: Codable, JSONEncodable, Hashable {
    public var id: Int?
    public var name: String?
    public var opal: String?
    public var hostname: String?
    public var thingName: String?
    public var serialNumber: String?
    public var serialNumberBrief: String?
    public var softwareVersionNumber: String?
    public var nucleonConfigGroupName: String?
    public var org: GlobalListAcus200ResponseDataInnerOrg?
    public var ownedByOrg: GlobalListAcus200ResponseDataInnerOrg?
    public var acuModel: GlobalListAcus200ResponseDataInnerAcuModel?
    public var expansionBoards: [GlobalListAcus200ResponseDataInnerExpansionBoardsInner]?
    public var certOpal: String?
    public var iotCertOpal: String?
    public var awsIotCertArn: String?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var isVirtual: Bool?
    public var status: String?
    public var statusAt: Date?
    public var statusMessage: String?
    public var entryCount: Int?
    public var shadow: GlobalListAcus200ResponseDataInnerShadow?
    public var notes: String?
    public var locationRestriction: GlobalListAcus200ResponseDataInnerLocationRestriction?

    public init(
        id: Int? = nil,
        name: String? = nil,
        opal: String? = nil,
        hostname: String? = nil,
        thingName: String? = nil,
        serialNumber: String? = nil,
        serialNumberBrief: String? = nil,
        softwareVersionNumber: String? = nil,
        nucleonConfigGroupName: String? = nil,
        org: GlobalListAcus200ResponseDataInnerOrg? = nil,
        ownedByOrg: GlobalListAcus200ResponseDataInnerOrg? = nil,
        acuModel: GlobalListAcus200ResponseDataInnerAcuModel? = nil,
        expansionBoards: [GlobalListAcus200ResponseDataInnerExpansionBoardsInner]? = nil,
        certOpal: String? = nil,
        iotCertOpal: String? = nil,
        awsIotCertArn: String? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        isVirtual: Bool? = nil,
        status: String? = nil,
        statusAt: Date? = nil,
        statusMessage: String? = nil,
        entryCount: Int? = nil,
        shadow: GlobalListAcus200ResponseDataInnerShadow? = nil,
        notes: String? = nil,
        locationRestriction: GlobalListAcus200ResponseDataInnerLocationRestriction? = nil
    ) {
        self.id = id
        self.name = name
        self.opal = opal
        self.hostname = hostname
        self.thingName = thingName
        self.serialNumber = serialNumber
        self.serialNumberBrief = serialNumberBrief
        self.softwareVersionNumber = softwareVersionNumber
        self.nucleonConfigGroupName = nucleonConfigGroupName
        self.org = org
        self.ownedByOrg = ownedByOrg
        self.acuModel = acuModel
        self.expansionBoards = expansionBoards
        self.certOpal = certOpal
        self.iotCertOpal = iotCertOpal
        self.awsIotCertArn = awsIotCertArn
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isVirtual = isVirtual
        self.status = status
        self.statusAt = statusAt
        self.statusMessage = statusMessage
        self.entryCount = entryCount
        self.shadow = shadow
        self.notes = notes
        self.locationRestriction = locationRestriction
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case opal
        case hostname
        case thingName
        case serialNumber
        case serialNumberBrief
        case softwareVersionNumber
        case nucleonConfigGroupName
        case org
        case ownedByOrg
        case acuModel
        case expansionBoards
        case certOpal
        case iotCertOpal
        case awsIotCertArn
        case createdAt
        case updatedAt
        case isVirtual
        case status
        case statusAt
        case statusMessage
        case entryCount
        case shadow
        case notes
        case locationRestriction
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(opal, forKey: .opal)
        try container.encodeIfPresent(hostname, forKey: .hostname)
        try container.encodeIfPresent(thingName, forKey: .thingName)
        try container.encodeIfPresent(serialNumber, forKey: .serialNumber)
        try container.encodeIfPresent(serialNumberBrief, forKey: .serialNumberBrief)
        try container.encodeIfPresent(softwareVersionNumber, forKey: .softwareVersionNumber)
        try container.encodeIfPresent(nucleonConfigGroupName, forKey: .nucleonConfigGroupName)
        try container.encodeIfPresent(org, forKey: .org)
        try container.encodeIfPresent(ownedByOrg, forKey: .ownedByOrg)
        try container.encodeIfPresent(acuModel, forKey: .acuModel)
        try container.encodeIfPresent(expansionBoards, forKey: .expansionBoards)
        try container.encodeIfPresent(certOpal, forKey: .certOpal)
        try container.encodeIfPresent(iotCertOpal, forKey: .iotCertOpal)
        try container.encodeIfPresent(awsIotCertArn, forKey: .awsIotCertArn)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(isVirtual, forKey: .isVirtual)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(statusAt, forKey: .statusAt)
        try container.encodeIfPresent(statusMessage, forKey: .statusMessage)
        try container.encodeIfPresent(entryCount, forKey: .entryCount)
        try container.encodeIfPresent(shadow, forKey: .shadow)
        try container.encodeIfPresent(notes, forKey: .notes)
        try container.encodeIfPresent(locationRestriction, forKey: .locationRestriction)
    }
}
