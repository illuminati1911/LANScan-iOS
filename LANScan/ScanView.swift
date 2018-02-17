//
//  ScanView.swift
//  TestApp
//
//  Created by Ville Välimaa on 19/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import UIKit
import SpinKit

protocol ScanViewDelegate: class {
    func didPressInitialScan()
    func didSelectTargetDevice(index:Int)
}

class ScanView: UIView  {

    private let scanButton = with(UIButton()) { button in
        button.setTitle("Start Scan", for: UIControlState.normal)
        button.titleLabel?.font = UIFont(name: "Press Start 2P", size: 12.0)
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.installShadow(height: 2)
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.backgroundColor = UIColor(red:0.00, green:0.56, blue:0.76, alpha:1.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 0
        button.addTarget(self, action: #selector(scanButtonPressed), for: .touchUpInside)
    }
    
    private let scanningList = with(UITableView()) { list in
        list.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
        list.separatorColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
        list.separatorInset = .zero
        list.layoutMargins = .zero
        list.cellLayoutMarginsFollowReadableWidth = false
        list.tableFooterView = UIView(frame: CGRect.zero)
        list.alpha = 0
        list.register(HostCell.self, forCellReuseIdentifier: "cell")
    }
    
    private let spinner = with(RTSpinKitView(style: RTSpinKitViewStyle.stylePulse)) { tSpinner in
        tSpinner?.spinnerSize = 100
        tSpinner?.isHidden = true
    }
    
    weak var delegate:ScanViewDelegate?
    
    var foundHosts:Array<Host> = [] {
        didSet {
            scanningList.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
        addSubview(scanButton)
        addSubview(scanningList)
        addSubview(spinner ?? RTSpinKitView(frame: .zero))
        
        scanningList.delegate = self
        scanningList.dataSource = self
        
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
    
    func setUIModeToFinished() { showLoadingSpinner(show: false) }
    
    func setUIModeToScanning() {
        foundHosts.removeAll()
        scanningList.reloadData()
        showLoadingSpinner(show: true)
    }
    
    private func showLoadingSpinner(show:Bool) { spinner?.isHidden = !show }
    
    @objc private func scanButtonPressed(sender:AnyObject) {
        self.delegate?.didPressInitialScan()
    }
    
    private func makeConstraints() {
        scanButton.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(self).dividedBy(3)
            make.height.equalTo(self.scanButton.snp.width).dividedBy(2)
        }
        
        scanningList.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        spinner?.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
}
    
//-------------------- DELEGATES--------------------//
//
extension ScanView: UITableViewDelegate, UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HostCell
        cell.setHostDetails(host: foundHosts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectTargetDevice(index: indexPath.row)
    }
}
