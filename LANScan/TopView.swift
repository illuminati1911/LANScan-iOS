//
//  TopView.swift
//  TestApp
//
//  Created by Ville Välimaa on 22/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import UIKit

protocol TopViewDelegate: class {
    func didPressScan()
}

class TopView: UIView {

    weak var delegate:TopViewDelegate?
    var titleText:UILabel!
    var scanButton:UIButton!
    var searchButton:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        self.titleText = UILabel()
        self.titleText.font = UIFont(name: "Press Start 2P", size: 12.0)
        self.titleText.textColor = UIColor.white
        self.titleText.adjustsFontSizeToFitWidth = true
        self.titleText.textAlignment = NSTextAlignment.center
        self.titleText.text = Constants.STATUS_TITLE_IDLE
        self.titleText.installShadow(height: 2)
        self.addSubview(self.titleText)
        
        self.scanButton = UIButton()
        self.scanButton.setTitle("Scan", for: UIControlState.normal)
        self.scanButton.titleLabel?.font = UIFont(name: "Press Start 2P", size: 9.0)
        self.scanButton.isHidden = true
        self.scanButton.addTarget(self, action: #selector(scanButtonPressed), for: .touchUpInside)
        self.addSubview(self.scanButton)
        
        self.searchButton = UIButton()
        self.searchButton.titleLabel?.text = "LOL"
        self.searchButton.isHidden = true
        self.addSubview(self.searchButton)
        
        self.makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStatusText(text:String) {
        self.titleText.pushTransition(duration: 0.4)
        self.titleText.text = text
    }
    
    func initScanView() {
        self.scanButton.isHidden = false
        self.setUIModeToScanning()
    }
    
    func setUIModeToScanning() {
        self.setStatusText(text: Constants.STATUS_TITLE_SCANNING)
        self.scanButton.isEnabled = false
    }
    
    func setUIModeToFinished(hostCount:Int) {
        self.setStatusText(text: "\(hostCount) \(Constants.STATUS_TITLE_HOSTS_FOUND)")
        self.scanButton.isEnabled = true
    }
    
    func scanButtonPressed(sender:AnyObject) {
        self.delegate?.didPressScan()
    }
    
    func makeConstraints() {
        self.searchButton.snp.makeConstraints { (make) in
            make.height.equalTo(self)
            make.width.equalTo(self.snp.height)
            make.left.top.equalTo(self)
        }
        
        self.scanButton.snp.makeConstraints { (make) in
            make.height.equalTo(self)
            make.width.equalTo(self.snp.height)
            make.right.top.equalTo(self)
        }
        
        self.titleText.snp.makeConstraints { (make) in
            make.height.equalTo(self)
            make.top.equalTo(self)
            make.left.equalTo(self.searchButton.snp.right)
            make.right.equalTo(self.scanButton.snp.left)
        }
    }
}
