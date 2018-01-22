//
//  DeviceViewController.swift
//  LANScan
//
//  Created by Ville Välimaa on 18/02/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import UIKit

class DeviceViewController: UIViewController {

    let host: Host
    let portScanTerminal = HackerTerminal(typingDelay: 0.0015)
    
    init(host: Host) {
        self.host = host
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.09, green:0.20, blue:0.27, alpha:1.0)
        view.addSubview(portScanTerminal)
        
        makeConstraints()
        insertInitialTextToTerminal()
        startPortScan()
    }
    
    private func insertInitialTextToTerminal() {
        portScanTerminal.insertText("\nScanning for services in \(host.ipAddress ?? "UNKNOWN")\n")
    }
    
    private func startPortScan() {
        PortScanner
            .scanPortsOn(host)
            .subscribeNext { [weak self] services in
                let printable = services as? [String] ?? []
                printable.forEach { self?.portScanTerminal.insertText("SERVICE FOUND ON PORT: \($0)\n") }
        }
    }
    
    func makeConstraints() {
        portScanTerminal.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}
