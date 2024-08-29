//
// ListAcuDeployTags200ResponseMetaSiteSpecificAccess.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ListAcuDeployTags200ResponseMetaSiteSpecificAccess: Codable, JSONEncodable, Hashable {
    public var isSiteSpecific: Bool?
    public var siteIds: [Int]?
    public var siteIdsByScope: ListAcuDeployTags200ResponseMetaSiteSpecificAccessSiteIdsByScope?

    public init(
        isSiteSpecific: Bool? = nil,
        siteIds: [Int]? = nil,
        siteIdsByScope: ListAcuDeployTags200ResponseMetaSiteSpecificAccessSiteIdsByScope? = nil
    ) {
        self.isSiteSpecific = isSiteSpecific
        self.siteIds = siteIds
        self.siteIdsByScope = siteIdsByScope
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case isSiteSpecific
        case siteIds
        case siteIdsByScope
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isSiteSpecific, forKey: .isSiteSpecific)
        try container.encodeIfPresent(siteIds, forKey: .siteIds)
        try container.encodeIfPresent(siteIdsByScope, forKey: .siteIdsByScope)
    }
}