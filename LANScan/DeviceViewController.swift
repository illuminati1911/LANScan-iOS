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
        self.portScanTerminal?.insertText("Starting Nmap 7.40 ( https://nmap.org ) at 2017-02-26 11:27 EET\n")
        self.portScanTerminal?.insertText("Nmap scan report for 192.168.1.1\n")
        self.portScanTerminal?.insertText("Host is up (0.0093s latency).\n")
        self.portScanTerminal?.insertText("Not shown: 995 closed ports\n")
        self.portScanTerminal?.insertText("PORT     STATE SERVICE\n")
        self.portScanTerminal?.insertText("53/tcp   open  domain\n")
        self.portScanTerminal?.insertText("80/tcp   open  http\n")
        self.portScanTerminal?.insertText("515/tcp  open  printer\n")
        self.portScanTerminal?.insertText("9100/tcp open  jetdirect\n")
        self.portScanTerminal?.insertText("9998/tcp open  distinct32\n")
        self.portScanTerminal?.insertText("\n")
        self.portScanTerminal?.insertText("Nmap done: 1 IP address (1 host up) scanned in 0.20 seconds\n")
        
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
