//
//  Extensions.swift
//  TestApp
//
//  Created by Ville Välimaa on 17/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import UIKit
import ReactiveCocoa

// http://stackoverflow.com/questions/33632266/animate-text-change-of-uilabel
extension UIView {
    func pushTransition(duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromTop
        animation.duration = duration
        self.layer.add(animation, forKey: kCATransitionPush)
    }
}

extension HostnameResolver {
    static func getHost(ip:String) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable? in
            DispatchQueue.global().async {
                let hostname = HostnameResolver.getHostFromIPAddress((ip as NSString).cString(using: String.Encoding.ascii.rawValue))
                subscriber?.sendNext(Host(ipAddress: ip, hostname: hostname, macAddress: nil, manufacturer: nil))
                subscriber?.sendCompleted()
            }
            
            return RACDisposable(block: {
            })
        })
    }
}

extension MacFinder {
    static func addMacToHost(host:Host) -> Host {
        var mac = MacFinder.ip2mac(host.ipAddress)
        if (mac == nil) { mac = Constants.EMPTY }
        return Host(ipAddress: host.ipAddress, hostname: host.hostname, macAddress: mac, manufacturer: nil)
    }
}

extension UILabel {
    func installShadow(height:CGFloat) {
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: height)
        layer.shadowRadius = 0
    }
}

// Call this in viewDidLayoutSubviews
extension UIView {
    func installBottomBorder() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
