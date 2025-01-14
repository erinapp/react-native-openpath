//
// GlobalListAcus200ResponseDataInnerExpansionBoardsInner.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct GlobalListAcus200ResponseDataInnerExpansionBoardsInner: Codable, JSONEncodable, Hashable {
    public var id: Int?
    public var number: Double?
    public var acuModel: GlobalListAcus200ResponseDataInnerAcuModel?

    public init(id: Int? = nil, number: Double? = nil, acuModel: GlobalListAcus200ResponseDataInnerAcuModel? = nil) {
        self.id = id
        self.number = number
        self.acuModel = acuModel
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case number
        case acuModel
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(number, forKey: .number)
        try container.encodeIfPresent(acuModel, forKey: .acuModel)
    }
}
