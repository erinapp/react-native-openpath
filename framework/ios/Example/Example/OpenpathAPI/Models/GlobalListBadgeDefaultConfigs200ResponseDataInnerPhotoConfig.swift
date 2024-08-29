//
// GlobalListBadgeDefaultConfigs200ResponseDataInnerPhotoConfig.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct GlobalListBadgeDefaultConfigs200ResponseDataInnerPhotoConfig: Codable, JSONEncodable, Hashable {
    public var isEnabled: Bool?
    public var backgroundColor: String?
    public var centerX: Double?
    public var centerY: Double?
    public var width: Double?
    public var height: Double?
    public var borderRadius: Double?
    public var borderColor: String?

    public init(
        isEnabled: Bool? = nil,
        backgroundColor: String? = nil,
        centerX: Double? = nil,
        centerY: Double? = nil,
        width: Double? = nil,
        height: Double? = nil,
        borderRadius: Double? = nil,
        borderColor: String? = nil
    ) {
        self.isEnabled = isEnabled
        self.backgroundColor = backgroundColor
        self.centerX = centerX
        self.centerY = centerY
        self.width = width
        self.height = height
        self.borderRadius = borderRadius
        self.borderColor = borderColor
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case isEnabled
        case backgroundColor
        case centerX
        case centerY
        case width
        case height
        case borderRadius
        case borderColor
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
        try container.encodeIfPresent(borderRadius, forKey: .borderRadius)
        try container.encodeIfPresent(borderColor, forKey: .borderColor)
    }
}