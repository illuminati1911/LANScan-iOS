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

    var icon:UIImageView = UIImageView()
    var hostnameLabel:UILabel = UILabel()
    var ipLabel:UILabel = UILabel()
    var vendorLabel:UILabel = UILabel()
    var macLabel:UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red:0.13, green:0.19, blue:0.25, alpha:1.0)
        
        self.icon.contentMode = UIViewContentMode.center
        self.addSubview(icon)
        
        self.hostnameLabel |> initLabels
        self.ipLabel |> initLabels
        self.vendorLabel |> initLabels
        self.vendorLabel.textAlignment = NSTextAlignment.right
        self.macLabel |> initLabels
        self.macLabel.textAlignment = NSTextAlignment.right
        
        self.makeConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
    }
    
    func setVendorImage(vendor:String) {
        if (vendor == Constants.APPLE_COMPANY_NAME) {
            self.setCellImageNamed(name: "apple_logo.png")
        } else {
            self.setCellImageNamed(name: "radio.png")
        }
    }
    
    func setCellImageNamed(name:String) {
        self.icon.image = Utils.imageWithImage(image: UIImage(named: name)!, scaledToSize: CGSize(width: 65, height: 65))
    }
    
    private func makeConstraints() {
        self.icon.snp.makeConstraints { (make) in
            make.height.equalTo(self)
            make.width.equalTo(80)
            make.left.top.equalTo(self)
        }
        
        self.hostnameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(self).dividedBy(2)
            make.width.equalTo(self).dividedBy(2).inset(20)
            make.left.equalTo(self.icon.snp.right)
            make.top.equalTo(self)
        }
        
        self.ipLabel.snp.makeConstraints { (make) in
            make.height.equalTo(self).dividedBy(2)
            make.width.equalTo(self).dividedBy(2).inset(20)
            make.left.equalTo(self.icon.snp.right)
            make.top.equalTo(self.hostnameLabel.snp.bottom)
        }
        
        self.vendorLabel.snp.makeConstraints { (make) in
            make.height.equalTo(self).dividedBy(2)
            make.width.equalTo(self).dividedBy(2).inset(25)
            make.left.equalTo(self.hostnameLabel.snp.right)
            make.right.equalTo(self).inset(10)
            make.top.equalTo(self)
        }
        
        self.macLabel.snp.makeConstraints { (make) in
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
    
    func initLabels(label:UILabel) {
        label.font = UIFont(name: "Press Start 2P", size: 8.0)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.installShadow(height: 1)
        self.addSubview(label)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
