//
// ListAcuDeployTags200ResponseMetaAccessToken.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ListAcuDeployTags200ResponseMetaAccessToken: Codable, JSONEncodable, Hashable {
    public var scopeUpdatedAt: Date?

    public init(scopeUpdatedAt: Date? = nil) {
        self.scopeUpdatedAt = scopeUpdatedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case scopeUpdatedAt
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(scopeUpdatedAt, forKey: .scopeUpdatedAt)
    }
}