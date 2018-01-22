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
    
    private let titleLabel = with(UILabel()) { label in
        label.font = UIFont(name: "Press Start 2P", size: 12.0)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        label.text = Constants.STATUS_TITLE_IDLE
        label.installShadow(height: 2)
    }
    
    private let scanButton = with(UIButton()) { button in
        button.setTitle("Scan", for: UIControlState.normal)
        button.titleLabel?.font = UIFont(name: "Press Start 2P", size: 9.0)
        button.isHidden = true
        button.addTarget(self, action: #selector(scanButtonPressed), for: .touchUpInside)
    }
    
    private let searchButton = with(UIButton()) { button in
        button.titleLabel?.text = "Scan"
        button.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)

        addSubview(titleLabel)
        addSubview(scanButton)
        addSubview(searchButton)
        
        self.makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStatusText(text:String) {
        titleLabel.pushTransition(duration: 0.4)
        titleLabel.text = text
    }
    
    func initScanView() {
        scanButton.isHidden = false
        setUIModeToScanning()
    }
    
    func setUIModeToScanning() {
        setStatusText(text: Constants.STATUS_TITLE_SCANNING)
        scanButton.isEnabled = false
    }
    
    func setUIModeToFinished(hostCount:Int) {
        setStatusText(text: "\(hostCount) \(Constants.STATUS_TITLE_HOSTS_FOUND)")
        scanButton.isEnabled = true
    }
    
    @objc func scanButtonPressed(sender:AnyObject) {
        delegate?.didPressScan()
    }
    
    func makeConstraints() {
        searchButton.snp.makeConstraints { (make) in
            make.height.equalTo(self)
            make.width.equalTo(self.snp.height)
            make.left.top.equalTo(self)
        }
        
        scanButton.snp.makeConstraints { (make) in
            make.height.equalTo(self)
            make.width.equalTo(self.snp.height)
            make.right.top.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(self)
            make.top.equalTo(self)
            make.left.equalTo(self.searchButton.snp.right)
            make.right.equalTo(self.scanButton.snp.left)
        }
    }
}
