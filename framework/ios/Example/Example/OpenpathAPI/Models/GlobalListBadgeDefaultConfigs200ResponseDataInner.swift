//
// GlobalListBadgeDefaultConfigs200ResponseDataInner.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct GlobalListBadgeDefaultConfigs200ResponseDataInner: Codable, JSONEncodable, Hashable {
    public var id: Int?
    public var nameConfig: GlobalListBadgeDefaultConfigs200ResponseDataInnerNameConfig?
    public var customField1Config: GlobalListBadgeDefaultConfigs200ResponseDataInnerCustomField1Config?
    public var customField2Config: GlobalListBadgeDefaultConfigs200ResponseDataInnerCustomField1Config?
    public var backgroundConfig: GlobalListBadgeDefaultConfigs200ResponseDataInnerBackgroundConfig?
    public var photoConfig: GlobalListBadgeDefaultConfigs200ResponseDataInnerPhotoConfig?
    public var logoConfig: GlobalListBadgeDefaultConfigs200ResponseDataInnerLogoConfig?
    public var externalIdConfig: GlobalListBadgeDefaultConfigs200ResponseDataInnerCustomField1Config?
    public var backgroundPicture: GlobalListBadgeDefaultConfigs200ResponseDataInnerBackgroundPicture?
    public var logoPicture: GlobalListBadgeDefaultConfigs200ResponseDataInnerBackgroundPicture?
    public var badgeWidth: Double?
    public var badgeHeight: Double?
    public var badgeBorderRadius: Double?
    public var printWidth: Double?
    public var printHeight: Double?
    public var name: String?
    public var isMobile: Bool?

    public init(
        id: Int? = nil,
        nameConfig: GlobalListBadgeDefaultConfigs200ResponseDataInnerNameConfig? = nil,
        customField1Config: GlobalListBadgeDefaultConfigs200ResponseDataInnerCustomField1Config? = nil,
        customField2Config: GlobalListBadgeDefaultConfigs200ResponseDataInnerCustomField1Config? = nil,
        backgroundConfig: GlobalListBadgeDefaultConfigs200ResponseDataInnerBackgroundConfig? = nil,
        photoConfig: GlobalListBadgeDefaultConfigs200ResponseDataInnerPhotoConfig? = nil,
        logoConfig: GlobalListBadgeDefaultConfigs200ResponseDataInnerLogoConfig? = nil,
        externalIdConfig: GlobalListBadgeDefaultConfigs200ResponseDataInnerCustomField1Config? = nil,
        backgroundPicture: GlobalListBadgeDefaultConfigs200ResponseDataInnerBackgroundPicture? = nil,
        logoPicture: GlobalListBadgeDefaultConfigs200ResponseDataInnerBackgroundPicture? = nil,
        badgeWidth: Double? = nil,
        badgeHeight: Double? = nil,
        badgeBorderRadius: Double? = nil,
        printWidth: Double? = nil,
        printHeight: Double? = nil,
        name: String? = nil,
        isMobile: Bool? = nil
    ) {
        self.id = id
        self.nameConfig = nameConfig
        self.customField1Config = customField1Config
        self.customField2Config = customField2Config
        self.backgroundConfig = backgroundConfig
        self.photoConfig = photoConfig
        self.logoConfig = logoConfig
        self.externalIdConfig = externalIdConfig
        self.backgroundPicture = backgroundPicture
        self.logoPicture = logoPicture
        self.badgeWidth = badgeWidth
        self.badgeHeight = badgeHeight
        self.badgeBorderRadius = badgeBorderRadius
        self.printWidth = printWidth
        self.printHeight = printHeight
        self.name = name
        self.isMobile = isMobile
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case nameConfig
        case customField1Config
        case customField2Config
        case backgroundConfig
        case photoConfig
        case logoConfig
        case externalIdConfig
        case backgroundPicture
        case logoPicture
        case badgeWidth
        case badgeHeight
        case badgeBorderRadius
        case printWidth
        case printHeight
        case name
        case isMobile
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(nameConfig, forKey: .nameConfig)
        try container.encodeIfPresent(customField1Config, forKey: .customField1Config)
        try container.encodeIfPresent(customField2Config, forKey: .customField2Config)
        try container.encodeIfPresent(backgroundConfig, forKey: .backgroundConfig)
        try container.encodeIfPresent(photoConfig, forKey: .photoConfig)
        try container.encodeIfPresent(logoConfig, forKey: .logoConfig)
        try container.encodeIfPresent(externalIdConfig, forKey: .externalIdConfig)
        try container.encodeIfPresent(backgroundPicture, forKey: .backgroundPicture)
        try container.encodeIfPresent(logoPicture, forKey: .logoPicture)
        try container.encodeIfPresent(badgeWidth, forKey: .badgeWidth)
        try container.encodeIfPresent(badgeHeight, forKey: .badgeHeight)
        try container.encodeIfPresent(badgeBorderRadius, forKey: .badgeBorderRadius)
        try container.encodeIfPresent(printWidth, forKey: .printWidth)
        try container.encodeIfPresent(printHeight, forKey: .printHeight)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(isMobile, forKey: .isMobile)
    }
}
