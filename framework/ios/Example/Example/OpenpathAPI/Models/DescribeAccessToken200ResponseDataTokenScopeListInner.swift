//
// DescribeAccessToken200ResponseDataTokenScopeListInner.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct DescribeAccessToken200ResponseDataTokenScopeListInner: Codable, JSONEncodable, Hashable, QuestionChoice {
    public var org: DescribeAccessToken200ResponseDataTokenScopeListInnerOrg
    public var user: DescribeAccessToken200ResponseDataTokenScopeListInnerUser
    public var scope: [String]?
    public var scopeWithContext: [DescribeAccessToken200ResponseDataTokenScopeListInnerScopeWithContextInner]?

    var id: Int { org.id ?? user.id ?? 0 }
    public var description: String { org.name ?? "<unnamed>" }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case org
        case user
        case scope
        case scopeWithContext
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(org, forKey: .org)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encodeIfPresent(scope, forKey: .scope)
        try container.encodeIfPresent(scopeWithContext, forKey: .scopeWithContext)
    }
}
