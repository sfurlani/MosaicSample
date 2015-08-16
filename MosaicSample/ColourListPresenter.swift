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

final class ColourListPresenter : NSObject {
    let paletteCellIdentifier = "paletteCell"
    let apiPath = "http://www.colourlovers.com/api/palettes/top?format=json&showPaletteWidths=1"
    let tableView: UITableView
    var palettes: [Palette] = [Palette]()
    var batchSize = 20
    
    init(tableView: UITableView) {
        self.tableView = tableView
        
        super.init()
        
        self.tableView.dataSource = self
    }

    func fetch(range: Range<Int>, callback: Optional<([Palette]) -> ()>) {
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
    
    func next(callback: Optional<([Palette]) -> ()>) {
        
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
        // TODO:
        cell.textLabel?.text = palettes[indexPath.row].title
        return cell
    }
    
}

