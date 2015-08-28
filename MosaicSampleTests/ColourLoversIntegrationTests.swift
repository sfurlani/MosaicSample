//
//  ColourLoversIntegrationTests.swift
//  MosaicSample
//
//  Created by SFurlani on 8/16/15.
//  Copyright © 2015 Strong Fortress. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import MosaicSample

class ColourLoversIntegrationTests: XCTestCase {
    
    var urlSession: NSURLSession!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        urlSession = NSURLSession.sharedSession()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testThatAPIAccessHasNotChanged() {
        //Expectation
        let expectation = expectationWithDescription("Test that API Access has not changed")
        
        let url = NSURL(string: "http://www.colourlovers.com/api/palettes/top?format=json&showPaletteWidths=1")!
        let task = urlSession.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let error = error {
                XCTFail("Expectation Failed with error: \(error)")
                return
            }
            
            guard let response = response as? NSHTTPURLResponse else {
                XCTFail("Expectation Failed no response")
                return
            }
            
            XCTAssertEqual(response.statusCode, 200, "Expectation Failed invalid HTTP Status code \(response.statusCode)")
            
            guard let data = data else {
                XCTFail("Expectation Failed no return")
                return
            }
            
            let json = JSON(data: data)
            
            XCTAssertNotNil(json.null, "Expecation Failed data contained no JSON")
            
            guard let paletteArray = json.array else {
                XCTFail("Expectation Failed root not Array")
                return
            }
            
            
            XCTAssertNotEqual(paletteArray.count, 0, "Expectation Failed empty array")
            
            XCTAssertNotNil(paletteArray[0].null, "Expecation Failed array contains empty first element")

            let paletteJSON = paletteArray[0]
            
            do {
                let _ = try Palette(json: paletteJSON)
                expectation.fulfill()
            }
            catch {
                XCTFail("Expectation Failed with error: \(error)")
            }
            
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout(30.0) { (error: NSError?) -> Void in
            if let error = error {
                XCTFail("Expectation Failed with error: \(error)")
            }
        }
        
    }
    
}
