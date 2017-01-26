//
//  LANScanTests.swift
//  LANScanTests
//
//  Created by Ville Välimaa on 23/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import XCTest
import ReactiveCocoa
@testable import LANScan

class LANScanTests: XCTestCase {
    
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
    
    func testLanScanSignalForNil() {
        let expectation = self.expectation(description: "lan scan signal")
        LANScanner.scanNetworkForHosts().subscribeNext { (hosts:Any?) in
            XCTAssertNotNil(hosts)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testPingWrapperWithLocalhost() {
        let expectation = self.expectation(description: "localhost ping")
        let ping = PingWrapper(hostName: "localhost")
        ping.startPing { (hostname:String, found:Bool) in
            XCTAssertTrue(found)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    
    //TODO move this to UI tests
    func testUI() {
        let vc = ScanViewController()
        let _ = vc.view
        vc.setUIToScanning()
        XCTAssert(vc.topView.titleText.text == Constants.STATUS_TITLE_SCANNING)
    }
    
}
