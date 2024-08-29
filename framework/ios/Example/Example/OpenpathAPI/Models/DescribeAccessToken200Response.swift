//
// DescribeAccessToken200Response.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct DescribeAccessToken200Response: Codable, JSONEncodable, Hashable {
    public var data: DescribeAccessToken200ResponseData
    public var meta: ListAcuDeployTags200ResponseMeta

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case data
        case meta
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(data, forKey: .data)
        try container.encodeIfPresent(meta, forKey: .meta)
    }
}
