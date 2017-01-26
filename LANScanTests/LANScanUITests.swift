//
//  LANScanUITests.swift
//  LANScan
//
//  Created by Ville Välimaa on 26/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import XCTest
@testable import LANScan

class LANScanUITests: XCTestCase {
    
    var hosts:Array<Host>!
    var vc:ScanViewController!
    
    override func setUp() {
        super.setUp()
        self.vc = ScanViewController()
        let _ = vc.view
        self.hosts =
            [Host.init(ipAddress: "192.168.1.1", hostname: "testhostname", macAddress: "01:23:45:67:89:ab", manufacturer: "Company Inc."),
            Host.init(ipAddress: "192.168.1.2", hostname: "testhostname2", macAddress: "01:23:45:67:89:a2", manufacturer: "Company2 Inc."),
            Host.init(ipAddress: "192.168.1.3", hostname: "testhostname3", macAddress: "01:23:45:67:89:a3", manufacturer: "Company3 Inc.")]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScanningStatusMessage() {
        vc.setUIToScanning()
        XCTAssert(vc.topView.titleText.text == Constants.STATUS_TITLE_SCANNING)
    }
    
    func testScanningFinishedStatusMessage() {
        vc.setUIToFinished(hostCount: hosts.count)
        vc.scanView.foundHosts = hosts
        vc.scanView.scanningList.reloadData()
        XCTAssert(vc.topView.titleText.text == "\(self.hosts.count) hosts found")
    }
    
    func testScanningFinishedCellData() {
        vc.setUIToFinished(hostCount: hosts.count)
        vc.scanView.foundHosts = hosts
        vc.scanView.scanningList.reloadData()
        let cell:HostCell = vc.scanView.scanningList.cellForRow(at: IndexPath(item: 0, section: 0)) as! HostCell
        XCTAssert(cell.ipLabel.text == self.hosts[0].ipAddress!)
        XCTAssert(cell.hostnameLabel.text == self.hosts[0].hostname!)
        XCTAssert(cell.macLabel.text == self.hosts[0].macAddress!)
        XCTAssert(cell.vendorLabel.text == self.hosts[0].manufacturer!)
    }
    
}
