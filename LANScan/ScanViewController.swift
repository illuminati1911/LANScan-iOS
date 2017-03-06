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

class ScanViewController: UIViewController, ScanViewDelegate, TopViewDelegate {

    var topView:TopView!
    var scanView:ScanView!
    var pingers:Array<PingWrapper>?
    var hosts:Array<Host> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.09, green:0.20, blue:0.27, alpha:1.0)
        
        self.topView = TopView(frame: CGRect.zero)
        self.topView.delegate = self
        self.view.addSubview(self.topView)
 
        self.scanView = ScanView(frame: CGRect.zero)
        self.scanView.delegate = self
        self.view.addSubview(self.scanView)
        
        self.makeConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        self.topView.installBottomBorder()
    }
    
    //-------------------- NETWORK --------------------//
    
    func isOnWiFi() -> Bool {
        let isOnWiFi = WiFiCheck().isOnWiFi()
        if (!isOnWiFi) {
            self.presentNoWiFiWarning()
        }
        return isOnWiFi;
    }
    
    func startScanning() {
        LANScanner.scanNetworkForHosts().subscribeNext { [unowned self] (hosts:Any?) in
            let finalHosts = ((hosts as! RACTuple).allObjects() as! Array<Host>)
            self.setUIToFinished(hostCount: finalHosts.count)
            self.hosts = finalHosts
            self.scanView.foundHosts = finalHosts
            self.scanView.scanningList.reloadData()
        }
    }
    
    //-------------------- DELEGATES--------------------//
    
    func didPressInitialScan() {
        if(self.isOnWiFi()){
            self.scanView.initScanView()
            self.topView.initScanView()
            self.startScanning()
        }
    }
    
    func didPressScan() {
        if(self.isOnWiFi()){
            self.setUIToScanning()
            self.startScanning()
        }
    }
    
    func didSelectTargetDevice(index: Int) {
        let deviceVC:DeviceViewController = DeviceViewController(host: hosts[index])
        deviceVC.modalTransitionStyle = .flipHorizontal
        self.present(deviceVC, animated: true, completion: nil)
    }
    
    //-------------------- UI ACTIONS/ANIMATIONS --------------------//
    
    func setUIToScanning() {
        self.topView.setUIModeToScanning()
        self.scanView.setUIModeToScanning()
    }
    
    func setUIToFinished(hostCount:Int) {
        self.topView.setUIModeToFinished(hostCount: hostCount)
        self.scanView.setUIModeToFinished()
    }
    
    func presentNoWiFiWarning() {
        let alert = UIAlertController(title: Constants.NOTIFICATION_NO_WIFI_TITLE, message: Constants.NOTIFICATION_NO_WIFI_BODY, preferredStyle: .alert)
        let defaultButton = UIAlertAction(title: Constants.OK_BUTTON_LABEL, style: .default)
        alert.addAction(defaultButton)
        present(alert, animated: true)
    }
    
    //-------------------- CONSTRAINTS --------------------//
    
    func makeConstraints() {
        self.topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.height.equalTo(60)
        }
        
        self.scanView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
}
