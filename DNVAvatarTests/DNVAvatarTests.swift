//
//  DNVAvatarTests.swift
//  DNVAvatar
//
//  Created by Alexey Demin on 2017-07-20.
//  Copyright © 2017 Alexey Demin. All rights reserved.
//

import XCTest
import DNVAvatar

class DNVAvatarTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMD5() {
        XCTAssert("https://developer.apple.com/documentation/xctest".md5 == "88de95e2bc19273f1b93442fc2704ac9")
    }
    
    @available(iOS 10.0, *)
    func testExtendedAttributes() {
        let file = "Test"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("test")
        try? file.write(to: fileURL, atomically: true, encoding: .utf8)//.data(using: .utf8)!.write(to: fileURL)
        XCTAssert((try? String(contentsOf: fileURL, encoding: .utf8)) == file)
        
        let testTag = "OK"
        FileManager.default.setTag(testTag, ofItemAt: fileURL)
        XCTAssert(FileManager.default.tagOfItemAt(fileURL) == testTag)
        
        FileManager.default.setTag(nil, ofItemAt: fileURL)
        XCTAssert(FileManager.default.tagOfItemAt(fileURL) == nil)
        
        let testTime = Date.timeIntervalSinceReferenceDate
        FileManager.default.setTime(testTime, ofItemAt: fileURL)
        XCTAssert(FileManager.default.timeOfItemAt(fileURL) == testTime)
        
        FileManager.default.setTime(nil, ofItemAt: fileURL)
        XCTAssert(FileManager.default.timeOfItemAt(fileURL) == nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
