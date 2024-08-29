//
//  JSON.swift
//  Titanium
//
//  Created by Jacqueline Mak on 5/3/17.
//  Copyright © 2017 OpenPath Security, Inc. All rights reserved.
//

import Foundation

class JSON {
    public static func stringify(value: AnyObject, prettyPrinted: Bool = true) -> String {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : nil
        if JSONSerialization.isValidJSONObject(value) {
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: options!)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            } catch {
                return ""
            }
        }
        return ""
    }
}
