//
// ListAcuDeployTags200ResponseMetaSiteSpecificAccessSiteIdsByScope.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ListAcuDeployTags200ResponseMetaSiteSpecificAccessSiteIdsByScope: Codable, JSONEncodable, Hashable {
    public var string: [Int]?

    public init(string: [Int]? = nil) {
        self.string = string
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case string
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(string, forKey: .string)
    }
}
