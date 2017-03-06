//
//  DeviceViewController.swift
//  LANScan
//
//  Created by Ville Välimaa on 18/02/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import UIKit

class DeviceViewController: UIViewController {

    var host:Host?
    
    var deviceIcon:UIImage?
    var deviceLabel:UILabel?
    var deviceMac:UILabel?
    var deviceIP:UILabel?
    var deviceVendor:UILabel?
    
    var portScanButton:UIButton?
    var portScanTerminal:HackerTerminal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.09, green:0.20, blue:0.27, alpha:1.0)
        
        self.portScanTerminal = HackerTerminal(typingDelay: 0.0015)
        self.view.addSubview(self.portScanTerminal!)
        
        self.portScanTerminal?.insertText("\n")
        self.portScanTerminal?.insertText("Scanning for services in \(host?.ipAddress ?? "UNKNOWN")\n")
        
        if let uHost = self.host {
            PortScanner.scanPortsOn(host: uHost).subscribeNext { (services:Any?) in
                let printable = services as? [String] ?? []
                printable.forEach { self.portScanTerminal?.insertText("SERVICE FOUND ON PORT: \($0)\n") }
            }
        }
        
        self.makeConstraints()
    }
    
    func makeConstraints() {
        self.portScanTerminal?.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    convenience init(host:Host) {
        self.init()
        self.host = host
    }

}
