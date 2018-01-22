//
//  HostCell.swift
//  TestApp
//
//  Created by Ville Välimaa on 21/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import UIKit
import SnapKit

class HostCell: UITableViewCell {

    private let icon = with(UIImageView()) { imageView in
        imageView.contentMode = UIViewContentMode.center
    }
    
    private let hostnameLabel = with(UILabel()) { label in
        initLabel(label)
    }
    
    private let ipLabel = with(UILabel()) { label in
        initLabel(label)
    }
    
    private let vendorLabel = with(UILabel()) { label in
        initLabel(label)
        label.textAlignment = NSTextAlignment.right
    }
    
    private let macLabel = with(UILabel()) { label in
        initLabel(label)
        label.textAlignment = NSTextAlignment.right
    }
    
    static func initLabel(_ label:UILabel) {
        label.font = UIFont(name: "Press Start 2P", size: 8.0)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.installShadow(height: 1)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(red:0.13, green:0.19, blue:0.25, alpha:1.0)
        
        addSubview(icon)
        addSubview(hostnameLabel)
        addSubview(ipLabel)
        addSubview(vendorLabel)
        addSubview(macLabel)
        
        makeConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
    }
    
    func setHostDetails(host: Host) {
        hostnameLabel.text = host.hostname
        ipLabel.text = host.ipAddress
        macLabel.text = host.macAddress
        vendorLabel.text = host.manufacturer
        setCellImageNamed(name:
            host.manufacturer == Constants.APPLE_COMPANY_NAME
            ? "apple_logo.png"
            : "radio.png"
        )
    }
    
    func setCellImageNamed(name:String) {
        icon.image = Utils.imageWithImage(image: UIImage(named: name)!, scaledToSize: CGSize(width: 65, height: 65))
    }
    
    private func makeConstraints() {
        icon.snp.makeConstraints { (make) in
            make.height.equalTo(self)
            make.width.equalTo(80)
            make.left.top.equalTo(self)
        }
        
        hostnameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(self).dividedBy(2)
            make.width.equalTo(self).dividedBy(2).inset(20)
            make.left.equalTo(self.icon.snp.right)
            make.top.equalTo(self)
        }
        
        ipLabel.snp.makeConstraints { (make) in
            make.height.equalTo(self).dividedBy(2)
            make.width.equalTo(self).dividedBy(2).inset(20)
            make.left.equalTo(self.icon.snp.right)
            make.top.equalTo(self.hostnameLabel.snp.bottom)
        }
        
        vendorLabel.snp.makeConstraints { (make) in
            make.height.equalTo(self).dividedBy(2)
            make.width.equalTo(self).dividedBy(2).inset(25)
            make.left.equalTo(self.hostnameLabel.snp.right)
            make.right.equalTo(self).inset(10)
            make.top.equalTo(self)
        }
        
        macLabel.snp.makeConstraints { (make) in
            make.height.equalTo(self).dividedBy(2)
            make.width.equalTo(self).dividedBy(2).inset(25)
            make.left.equalTo(self.ipLabel.snp.right)
            make.right.equalTo(self).inset(10)
            make.top.equalTo(self.vendorLabel.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
