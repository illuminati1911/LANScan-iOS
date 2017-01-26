//
//  ScanView.swift
//  TestApp
//
//  Created by Ville Välimaa on 19/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import UIKit
import SpinKit

protocol ScanViewDelegate {
    func didPressInitialScan()
}

class ScanView: UIView, UITableViewDelegate, UITableViewDataSource  {

    var scanButton:UIButton!
    var scanningList:UITableView!
    var spinner:RTSpinKitView!
    var delegate:ScanViewDelegate?
    var foundHosts:Array<Host> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
        
        self.scanButton = UIButton()
        self.scanButton.setTitle("Start Scan", for: UIControlState.normal)
        self.scanButton.titleLabel?.font = UIFont(name: "Press Start 2P", size: 12.0)
        self.scanButton.titleLabel?.textColor = UIColor.white
        self.scanButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.scanButton.titleLabel?.installShadow(height: 2)
        self.scanButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.scanButton.backgroundColor = UIColor(red:0.00, green:0.56, blue:0.76, alpha:1.0)
        self.scanButton.layer.shadowOpacity = 1.0
        self.scanButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.scanButton.layer.shadowRadius = 0
        self.scanButton.addTarget(self, action: #selector(scanButtonPressed), for: .touchUpInside)
        self.addSubview(self.scanButton)
        
        self.scanningList = UITableView()
        self.scanningList.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
        self.scanningList.separatorColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
        self.scanningList.separatorInset = .zero
        self.scanningList.layoutMargins = .zero
        self.scanningList.cellLayoutMarginsFollowReadableWidth = false
        self.scanningList.tableFooterView = UIView(frame: CGRect.zero)
        self.scanningList.alpha = 0
        self.scanningList.delegate = self
        self.scanningList.dataSource = self
        self.scanningList.register(HostCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(self.scanningList)
        
        self.spinner = RTSpinKitView(style: RTSpinKitViewStyle.stylePulse)
        self.spinner.spinnerSize = 100
        self.spinner.isHidden = true
        self.addSubview(self.spinner)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initScanView() {
        UIView.animate(withDuration: 0.7, animations: { 
            self.scanButton.alpha = 0.0
            self.scanningList.alpha = 1.0
        }) { (Bool) in
            self.showLoadingSpinner(show: true)
        }
    }
    
    func setUIModeToScanning() {
        self.foundHosts = []
        self.scanningList.reloadData()
        self.showLoadingSpinner(show: true)
    }
    
    func setUIModeToFinished() {
        self.showLoadingSpinner(show: false)
    }
    
    func showLoadingSpinner(show:Bool) {
        self.spinner.isHidden = !show
    }
    
    func scanButtonPressed(sender:AnyObject) {
        self.delegate?.didPressInitialScan()
    }
    
    private func makeConstraints() {
        self.scanButton.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(self).dividedBy(3)
            make.height.equalTo(self.scanButton.snp.width).dividedBy(2)
        }
        
        self.scanningList.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.spinner.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
    //-------------------- DELEGATES--------------------//
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foundHosts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HostCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HostCell
        
        cell.hostnameLabel.text = foundHosts[indexPath.row].hostname
        cell.ipLabel.text = foundHosts[indexPath.row].ipAddress
        cell.macLabel.text = foundHosts[indexPath.row].macAddress
        cell.vendorLabel.text = foundHosts[indexPath.row].manufacturer
        cell.setVendorImage(vendor: foundHosts[indexPath.row].manufacturer!)
        
        return cell
    }
}
