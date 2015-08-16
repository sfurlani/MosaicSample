//
//  UIColor+Hex.swift
//  MosaicSample
//
//  Created by SFurlani on 8/15/15.
//  Copyright © 2015 Strong Fortress. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /// Converts a typical HTML Hex Color string into a `UIColor`
    /// - parameter rgba: Must be of the following formats: #RGB, #RGBA, #RRGGBB, #RRGGBBAA
    public convenience init?(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        let hex: String
        if rgba.hasPrefix("#") {
            let index   = advance(rgba.startIndex, 1) // handles UTF8/Graphmeme stuff?
            hex     = rgba.substringFromIndex(index)
        }
        else {
            hex = rgba
        }
        
        let scanner = NSScanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexLongLong(&hexValue) {
            switch (hex.characters.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                return nil
            }
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
