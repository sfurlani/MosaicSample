//
//  ColourListPresenter.swift
//  MosaicSample
//
//  Created by SFurlani on 8/14/15.
//  Copyright © 2015 Strong Fortress. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

/// Presenter which downloads Palettes and exposes them to the UITableView
final class ColourListPresenter : NSObject {
    
    typealias PaletteFetchCallbackType = ([Palette]) -> ()
    
    /// The PaletteCell's Identifier (currenlty a `basicCell`)
    let paletteCellIdentifier = "paletteCell"
    
    /// API Path with default query parameters
    let apiPath = "http://www.colourlovers.com/api/palettes/top?format=json&showPaletteWidths=1"
    
    /// The target TableView
    let tableView: UITableView
    
    /// The current list of Palettes
    private(set) var palettes: [Palette] = [Palette]()
    
    /// How many to fetch during each
    var batchSize = 20
    
    /// Init with target TableView
    /// - parameter tableView: Assigns the `dataSource` as `self`
    init(tableView: UITableView) {
        self.tableView = tableView
        
        super.init()
        
        self.tableView.dataSource = self
    }

    /// Downloads and saves to `palettes`
    /// - parameter range: Range of Palettes to fetch
    /// - parameter callback: will be called with the `new` values, **after** `self.palettes` mutates
    /// - warning: mutates `self.palettes`
    func fetch(range: Range<Int>, callback: PaletteFetchCallbackType?) {
        let session = NSURLSession.sharedSession()
        let baseURL = NSURL(string: apiPath + "&numResults=\(range.count)&resultOffset=\(range.startIndex)")!
        
        let task = session.dataTaskWithURL(baseURL) { (dataIn: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let err = error {
                print(err)
                return
            }
            
            guard let data = dataIn else {
                print("No Data")
                return
            }
            
            let jsonArray = JSON(data: data)
            
            let paletteArray = jsonArray.arrayValue.reduce([Palette]()) {
                do {
                    return $0 + [try Palette(json: $1)]
                }
                catch ParseErrorType.ValueIncorrectType(let key, let value) {
                    print ("Could Not Parse: [\"\(key)\" : \"\(value)\"]")
                }
                catch {
                    print (error)
                }
                return $0
            }
            
            self.palettes = self.palettes + paletteArray;
            defer { callback?(paletteArray) }
        }
        
        task.resume()

    }
    
    /// Downloads the next set of Palettes according to the current `self.batchSize` and `self.palettes.count`
    /// - parameter callback: will be called with the `new` values, **after** `self.palettes` mutates
    /// - warning: convenience call for `fetch(range:callback:)`
    func next(callback: PaletteFetchCallbackType?) {
        
        let start = self.palettes.count
        let end   = start + batchSize
        let range = start..<end
        
        print("Fetching: \(range)")
        
        fetch(range) { (nextPalettes: [Palette]) -> () in
            dispatch_async(dispatch_get_main_queue(), {
                defer { callback?(nextPalettes) }
                
                let indexPaths = range.map { NSIndexPath(forRow: $0, inSection: 0) }
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
                self.tableView.endUpdates()
            })
        }
    }
    
}

// MARK: - UITableViewDataSource
extension ColourListPresenter : UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return palettes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(paletteCellIdentifier, forIndexPath: indexPath)
        // TODO: add more features like image and subtitle
        cell.textLabel?.text = palettes[indexPath.row].title
        cell.detailTextLabel?.text = palettes[indexPath.row].userName
        return cell
    }
    
}

