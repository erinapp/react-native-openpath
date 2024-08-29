//
// ListCredentialConfigs200ResponseDataInnerCredentialPincode.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ListCredentialConfigs200ResponseDataInnerCredentialPincode: Codable, JSONEncodable, Hashable {
    public var id: Double?
    public var number: String?

    public init(id: Double? = nil, number: String? = nil) {
        self.id = id
        self.number = number
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case number
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(number, forKey: .number)
    }
}
