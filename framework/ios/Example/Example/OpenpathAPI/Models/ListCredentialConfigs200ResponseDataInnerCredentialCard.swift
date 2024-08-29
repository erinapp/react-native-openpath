//
// ListCredentialConfigs200ResponseDataInnerCredentialCard.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ListCredentialConfigs200ResponseDataInnerCredentialCard: Codable, JSONEncodable, Hashable {
    public var id: Double?
    public var number: String?
    public var numBits: Int?
    public var isOutputEnabled: Bool?
    public var cardFormat: ListCredentialConfigs200ResponseDataInnerCredentialCardCardFormat?
    public var facilityCode: String?
    public var cardId: String?
    public var fields: ListCredentialConfigs200ResponseDataInnerCredentialCardFields?

    public init(
        id: Double? = nil,
        number: String? = nil,
        numBits: Int? = nil,
        isOutputEnabled: Bool? = nil,
        cardFormat: ListCredentialConfigs200ResponseDataInnerCredentialCardCardFormat? = nil,
        facilityCode: String? = nil,
        cardId: String? = nil,
        fields: ListCredentialConfigs200ResponseDataInnerCredentialCardFields? = nil
    ) {
        self.id = id
        self.number = number
        self.numBits = numBits
        self.isOutputEnabled = isOutputEnabled
        self.cardFormat = cardFormat
        self.facilityCode = facilityCode
        self.cardId = cardId
        self.fields = fields
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case number
        case numBits
        case isOutputEnabled
        case cardFormat
        case facilityCode
        case cardId
        case fields
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(number, forKey: .number)
        try container.encodeIfPresent(numBits, forKey: .numBits)
        try container.encodeIfPresent(isOutputEnabled, forKey: .isOutputEnabled)
        try container.encodeIfPresent(cardFormat, forKey: .cardFormat)
        try container.encodeIfPresent(facilityCode, forKey: .facilityCode)
        try container.encodeIfPresent(cardId, forKey: .cardId)
        try container.encodeIfPresent(fields, forKey: .fields)
    }
}
