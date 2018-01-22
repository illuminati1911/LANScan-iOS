//
//  WiFiCheck.swift
//  TestApp
//
//  Created by Ville Välimaa on 19/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

class WiFiCheck: NSObject {
    
    var hostReachability:Reachability?
    
    
    func isOnWiFi() -> Bool {
        let host = "http://www.google.com"
        hostReachability = Reachability(hostName: host)
        if hostReachability?.currentReachabilityStatus() == ReachableViaWiFi {
            return true
        }
        return false
    }
}
