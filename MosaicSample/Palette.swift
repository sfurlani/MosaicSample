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

/**
## ColourLover's Palette
Please reference the [online api](http://www.colourlovers.com/api)
*/
struct Palette {

    let id: Int
    let title: String
    let userName: String
    let colorWidths: [CGFloat]
    let colors: [UIColor]
    let numViews: Int
    let numVotes: Int
    let numComments: Int
    let numHearts: Double
    let rank: Int
    let dateCreated: NSDate
    // let description: String?
    let url: NSURL?
    let imageUrl: NSURL?
    let badgeUrl: NSURL?
    let apiUrl: NSURL?
    
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
    
    init(json: JSON) throws {
        
        // Known JSON Types
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
        
        // NSDate not a standard JSOn type
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = json[Keys.dateCreated].stringValue
        guard let date = formatter.dateFromString(dateString) else {
            throw ParseErrorType.ValueIncorrectType(key: Keys.dateCreated, value: json[Keys.dateCreated])
        }
        dateCreated = date
        
    }
    
    var hasUniformWidths: Bool {
        return colorWidths.reduce(true) {
            $0 && colorWidths.first! == $1
        }
    }
    
}

extension Palette : CustomStringConvertible {
    
    /// pretty-prints the colors
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
    
    var description: String {
        
        return "<Palette> \(title)(\(id))\n\t[\(colorsDescription)]\n\t[\(colorWidthsDescription)]"
    }
}

extension Palette : Equatable {
    func equalTo(test: Palette) -> Bool {
        return self.id == test.id
    }
}
func ==(lhs: Palette, rhs: Palette) -> Bool {
    return lhs.equalTo(rhs)
}

extension Palette : Hashable {
    var hashValue: Int {
        return self.id
    }
}
