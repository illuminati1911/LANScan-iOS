//
//  ScanViewController.swift
//  TestApp
//
//  Created by Ville Välimaa on 17/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveCocoa

class ScanViewController: UIViewController {
    
    let topView = TopView()
    let scanView = ScanView()
    var pingers:Array<PingWrapper>?
    var hosts:Array<Host> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.09, green:0.20, blue:0.27, alpha:1.0)
        
        topView.delegate = self
        scanView.delegate = self
        
        view.addSubview(self.topView)
        view.addSubview(self.scanView)
        makeConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        self.topView.installBottomBorder()
    }
    
//-------------------- NETWORK --------------------//
//
    func startScanning() {
        LANScanner
            .scanNetworkForHosts()
            .subscribeNext { [weak self] (hosts:Any?) in
                let finalHosts = ((hosts as? RACTuple)?.allObjects() as? Array<Host>)
                if let fHosts = finalHosts {
                    self?.setUIToFinished(hostCount: fHosts.count)
                    self?.hosts = fHosts
                    self?.scanView.foundHosts = fHosts
                }
        }
    }
    
//-------------------- UI ACTIONS/ANIMATIONS/CONSTRAINTS --------------------//
//
    func setUIToScanning() {
        topView.setUIModeToScanning()
        scanView.setUIModeToScanning()
    }
    
    func setUIToFinished(hostCount:Int) {
        topView.setUIModeToFinished(hostCount: hostCount)
        scanView.setUIModeToFinished()
    }
    
    func presentNoWiFiWarning() {
        let alert = UIAlertController(title: Constants.NOTIFICATION_NO_WIFI_TITLE,
                                      message: Constants.NOTIFICATION_NO_WIFI_BODY,
                                      preferredStyle: .alert)
        let defaultButton = UIAlertAction(title: Constants.OK_BUTTON_LABEL, style: .default)
        alert.addAction(defaultButton)
        present(alert, animated: true)
    }

    func makeConstraints() {
        topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.height.equalTo(60)
        }
        
        scanView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
}

//-------------------- DELEGATES--------------------//
//
extension ScanViewController: ScanViewDelegate, TopViewDelegate {
    
    func didPressInitialScan() {
        if WiFiCheck().isOnWiFi() {
            scanView.initScanView()
            topView.initScanView()
            startScanning()
        } else {
            presentNoWiFiWarning()
        }
    }
    
    func didPressScan() {
        if WiFiCheck().isOnWiFi() {
            setUIToScanning()
            startScanning()
        } else {
            presentNoWiFiWarning()
        }
    }
    
    func didSelectTargetDevice(index: Int) {
        let deviceVC = DeviceViewController(host: hosts[index])
        deviceVC.modalTransitionStyle = .flipHorizontal
        present(deviceVC, animated: true, completion: nil)
    }
}
