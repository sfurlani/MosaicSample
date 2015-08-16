//
//  Palette.swift
//  MosaicSample
//
//  Created by SFurlani on 8/15/15.
//  Copyright © 2015 Strong Fortress. All rights reserved.
//

import Swift
import Foundation
import SwiftyJSON
import UIKit

/// ErrorType for creating/parsing the `Pallete` object from [ColourLover's API](http://www.colourlovers.com/api)
enum ParseErrorType : ErrorType {
    
    /// The value cannot be case to the required Type
    /// - parameter key: The key required
    /// - parameter value: The invalid object
    case ValueIncorrectType(key: String, value: JSON)
    
}


/// ColourLover's Palette
/// - Please reference the [online api](http://www.colourlovers.com/api)
/// - warning: the parameter `description` clashes with CocoaTouch naming.  Dropped as we're not rending any HTML
struct Palette {

    /// API ID for the Palette
    let id: Int
    
    /// Title (Unicode)
    let title: String
    
    /// User's Name
    let userName: String
    
    /// Color Widths for the palette.  Defaults to equal-widths
    let colorWidths: [CGFloat]
    
    /// Colors converted from Hex strings
    let colors: [UIColor]
    
    /// Number of Views the Palette has had
    let numViews: Int
    
    /// Number of Votes the Palette has had
    let numVotes: Int
    
    /// Number of Comments on the Palette
    let numComments: Int
    
    /// A rating system, ranges 0.0 - 5.0 in 0.5 chunks
    let numHearts: Double
    
    /// Ranking for overall Palettes
    let rank: Int
    
    /// Date Palette was created
    let dateCreated: NSDate

    /// HTML webpage url for the Palette
    let url: NSURL?
    
    /// Image URL (jpeg I think)
    let imageUrl: NSURL?
    
    /// Image URL but with extra data (like stack overflow's badges)
    let badgeUrl: NSURL?
    
    /// API URL to return JSON
    let apiUrl: NSURL?
    
    /// Set the Keys as constants
    private struct Keys {
        static let id = "id"
        static let title = "title"
        static let userName = "userName"
        static let colorWidths = "colorWidths"
        static let numViews = "numViews"
        static let numVotes = "numVotes"
        static let numComments = "numComments"
        static let numHearts = "numHearts"
        static let rank = "rank"
        static let url = "url"
        static let imageUrl = "imageUrl"
        static let badgeUrl = "badgeUrl"
        static let apiUrl = "apiUrl"
        static let colors = "colors"
        static let dateCreated = "dateCreated"
    }
    
    /// Initializes a Palette from a SwiftyJSON object
    /// - parameter json: Expects a dictionary as root
    /// - throws: ParseErrorType.ValueIncorrectType
    init(json: JSON) throws {
        
        // Known JSON Types, these should always exist so using non-Optional accessors is easier to read
        id = json[Keys.id].intValue
        title = json[Keys.title].stringValue
        userName = json[Keys.userName].stringValue
        colorWidths = json[Keys.colorWidths].arrayValue.map { CGFloat($0.doubleValue)  }
        numViews = json[Keys.numViews].intValue
        numVotes = json[Keys.numVotes].intValue
        numComments = json[Keys.numComments].intValue
        numHearts = json[Keys.numHearts].doubleValue
        rank = json[Keys.rank].intValue
        
        // Optional castings
        // description = json["description"].string
        url = NSURL(string: json[Keys.url].stringValue)
        imageUrl = NSURL(string: json[Keys.imageUrl].stringValue)
        badgeUrl = NSURL(string: json[Keys.badgeUrl].stringValue)
        apiUrl = NSURL(string: json[Keys.apiUrl].stringValue)
        
        // UIColor not a standard JSON type
        let colorString: [String] = json[Keys.colors].arrayValue.map { $0.stringValue }
        colors = colorString.reduce([UIColor]()) {
            if let color = UIColor(rgba:$1) {
                return $0 + [color]
            }
            return $0
        }
        // not all converted to colors?
        if (colors.count != colorString.count) {
            throw ParseErrorType.ValueIncorrectType(key: Keys.colors, value: json[Keys.colors])
        }
        
        // NSDate not a standard JSON type
        let formatter = NSDateFormatter()
        // Format defined by ColourLovers' API
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // Convert String to NSDate
        guard let date = formatter.dateFromString(json[Keys.dateCreated].stringValue) else {
            throw ParseErrorType.ValueIncorrectType(key: Keys.dateCreated, value: json[Keys.dateCreated])
        }
        dateCreated = date
        
    }
    
    /// returns whether or not the Palette has uniform widths (the default)
    var hasUniformWidths: Bool {
        return colorWidths.reduce(true) { $0 && colorWidths.first! == $1 }
    }
    
}

extension Palette : CustomStringConvertible {
    
    /// pretty-prints the colors
    /// - note: removes the `UIDeviceRGBColorSpace` in the default printing for `UIColor`
    var colorsDescription: String {
        let colorStrings = colors.map { $0.description }
        let trimmed = colorStrings.map { $0.stringByReplacingOccurrencesOfString("UIDeviceRGBColorSpace ", withString: "") }
        let wrapped = trimmed.map { "{\($0)}" }
        return ", ".join(wrapped)
    }
    
    /// pretty-prints the colorWidths
    var colorWidthsDescription: String {
        return ", ".join(colorWidths.map { "\($0)" })
    }
    
    /// Prints `title(id) [colors] [widths]`
    var description: String {
        return "<Palette> \(title)(\(id))\n\t[\(colorsDescription)]\n\t[\(colorWidthsDescription)]"
    }
}

extension Palette : Equatable {
    /// underlying function for `==`
    func equalTo(test: Palette) -> Bool {
        return self.id == test.id
    }
}

/// Calls `equalTo(test:)` on rhs from lhs
func ==(lhs: Palette, rhs: Palette) -> Bool {
    return lhs.equalTo(rhs)
}

extension Palette : Hashable {
    /// The palette's `id` provides the universal unique Identifier
    var hashValue: Int {
        return self.id
    }
}
