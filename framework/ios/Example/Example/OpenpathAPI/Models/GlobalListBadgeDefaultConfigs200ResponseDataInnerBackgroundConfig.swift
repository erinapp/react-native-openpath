//
// GlobalListBadgeDefaultConfigs200ResponseDataInnerBackgroundConfig.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct GlobalListBadgeDefaultConfigs200ResponseDataInnerBackgroundConfig: Codable, JSONEncodable, Hashable {
    public var isEnabled: Bool?
    public var backgroundColor: String?
    public var centerX: Double?
    public var centerY: Double?
    public var width: Double?
    public var height: Double?

    public init(
        isEnabled: Bool? = nil,
        backgroundColor: String? = nil,
        centerX: Double? = nil,
        centerY: Double? = nil,
        width: Double? = nil,
        height: Double? = nil
    ) {
        self.isEnabled = isEnabled
        self.backgroundColor = backgroundColor
        self.centerX = centerX
        self.centerY = centerY
        self.width = width
        self.height = height
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case isEnabled
        case backgroundColor
        case centerX
        case centerY
        case width
        case height
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isEnabled, forKey: .isEnabled)
        try container.encodeIfPresent(backgroundColor, forKey: .backgroundColor)
        try container.encodeIfPresent(centerX, forKey: .centerX)
        try container.encodeIfPresent(centerY, forKey: .centerY)
        try container.encodeIfPresent(width, forKey: .width)
        try container.encodeIfPresent(height, forKey: .height)
    }
}
