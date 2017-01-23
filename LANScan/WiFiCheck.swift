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
        self.hostReachability = Reachability(hostName: host)
        //self.reachabilityChanged()
        if self.hostReachability!.currentReachabilityStatus() == ReachableViaWiFi {
            return true
        }
        return false
    }

    //TODO MAKE THIS EVENT BASED
    /*func reachabilityChanged() {
        if self.hostReachability!.currentReachabilityStatus() == ReachableViaWiFi {
            print("Wifi")
        }
            
        if self.hostReachability!.currentReachabilityStatus() == ReachableViaWWAN {
            print("4G")
        }
            
        if self.hostReachability!.currentReachabilityStatus() == NotReachable {
            print("No connection")
        }
    }*/
}
