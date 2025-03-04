//
// DescribeAccessToken200ResponseDataTokenScopeListInnerScopeWithContextInnerContextInner.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct DescribeAccessToken200ResponseDataTokenScopeListInnerScopeWithContextInnerContextInner: Codable,
    JSONEncodable, Hashable {
    public var mfa: Bool?
    public var fsa: Bool?

    public init(mfa: Bool? = nil, fsa: Bool? = nil) {
        self.mfa = mfa
        self.fsa = fsa
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case mfa
        case fsa
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(mfa, forKey: .mfa)
        try container.encodeIfPresent(fsa, forKey: .fsa)
    }
}
