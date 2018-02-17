//
//  WiFiCheck.swift
//  TestApp
//
//  Created by Ville Välimaa on 19/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

class WiFiCheck {
    
    static func isOnWiFi() -> Bool {
        let host = "http://www.google.com"
        let hostReachability = Reachability(hostName: host)
        if hostReachability?.currentReachabilityStatus() == ReachableViaWiFi {
            return true
        }
        return false
    }
}
