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
    
    var hosts: Array<Host> = []
    
    override func setUp() {
        super.setUp()
        self.hosts =
            [Host.init(ipAddress: "192.168.1.1", hostname: "testhostname", macAddress: "ac:bc:32:99:63:c3", manufacturer: "Company Inc."),
             Host.init(ipAddress: "192.168.1.2", hostname: "testhostname2", macAddress: "14:c9:13:9f:d6:71", manufacturer: "Company2 Inc."),
             Host.init(ipAddress: "192.168.1.3", hostname: "testhostname3", macAddress: "01:23:45:67:89:a3", manufacturer: "Company3 Inc.")]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    
    func testVendorForMAC() {
        let expectation = self.expectation(description: "vendor for mac")
        APIManager.signalForManufacturer(host:
            Host.init(ipAddress: "", hostname: "", macAddress: "ac:bc:32:99:63:c3", manufacturer: ""))
            .subscribeNext { (host:Any?) in
                XCTAssert((host as! Host).manufacturer == Constants.APPLE_COMPANY_NAME)
                expectation.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testVendorsForMACs() {
        let expectation = self.expectation(description: "vendors for mac")
        APIManager.signalForManufacturers(hosts: self.hosts)
            .subscribeNext { (hosts:Any?) in
                let allhosts = ((hosts as! RACTuple).allObjects() as! Array<Host>)
                XCTAssert(allhosts[0].manufacturer == Constants.APPLE_COMPANY_NAME)
                XCTAssert(allhosts[1].manufacturer == Constants.LG_ELECTRONICS_COMPANY_NAME)
                XCTAssert(allhosts[2].manufacturer == Constants.VENDOR_NOT_FOUND_RESPONSE)
                expectation.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
