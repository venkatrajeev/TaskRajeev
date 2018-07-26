//
//  Rajeev_TaskTests.swift
//  Rajeev_TaskTests
//
//  Created by Bharath Thatikonda on 26/07/18.
//  Copyright © 2018 Gemini. All rights reserved.
//

import XCTest
@testable import Rajeev_Task


class Rajeev_TaskTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testServiceCallData() {
        let mainClass: ViewController = ViewController()
        let dataString = mainClass.getTextFrom((URL.init(string:ObjectManager.sharedObjectManager().serviceURL)!))
        let responseData = dataString?.data(using: .utf8)
        let json = try! JSONSerialization.jsonObject(with: responseData!, options: .mutableContainers) as? Dictionary<String, AnyObject?>
        if let dictionaryArray = json {
            XCTAssertTrue(dictionaryArray.count>0)
        }
    }
    
    func testLocalData() {
        do {
            let localDB:NSArray = try
                context.fetch(Facts.fetchRequest()) as NSArray
            XCTAssertTrue(localDB.count>0)
        }
        catch {
        }
    }
}
