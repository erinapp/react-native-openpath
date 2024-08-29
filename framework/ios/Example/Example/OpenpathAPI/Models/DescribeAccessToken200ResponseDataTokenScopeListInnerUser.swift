//
// DescribeAccessToken200ResponseDataTokenScopeListInnerUser.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct DescribeAccessToken200ResponseDataTokenScopeListInnerUser: Codable, JSONEncodable, Hashable {
    public var id: Int?
    public var opal: String?

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case opal
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(opal, forKey: .opal)
    }
}