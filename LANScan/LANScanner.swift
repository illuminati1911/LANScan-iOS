//
//  LANScanner.swift
//  TestApp
//
//  Created by Ville Välimaa on 21/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import ReactiveCocoa

class LANScanner {
    
    static func scanNetworkForHosts() -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable? in
            LANScanner.scan()
                .flattenMap({ (hosts: Any?) -> RACSignal? in
                    return hosts |> signalForHostnamesAndMAC
                }).flattenMap({ (hosts: Any?) -> RACSignal? in
                    return hosts |> APIManager.signalForManufacturers
                })
                .deliverOnMainThread()
                .subscribeNext({ (hosts: Any?) in
                    subscriber?.sendNext(hosts)
                    subscriber?.sendCompleted()
                })
            
            return RACDisposable(block: {
            })
        })
    }
    
    static private func scan() -> RACSignal {
        let prefix = getIPPrefix()
        if (prefix != Constants.NO_WIFI_ADDRESS) {
            let signals = Array(1...254)
                .map { "\(prefix).\($0)" }
                .map { PingWrapper(hostName: $0) }
                .map { signalForPing(ping: $0) }
            return RACSignal.combineLatest(signals as NSArray)
        }
        return RACSignal()
    }
    
    static private func signalForHostnamesAndMAC(hosts: Any?) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable? in
            (((hosts as! RACTuple).allObjects() as! Array<String>)
            .filter { $0 != Constants.PING_HOST_NOT_FOUND }
            .map { HostnameResolver.getHost(ip: $0) } as NSArray
            |> RACSignal.combineLatest)
            .map({ (hosts: Any?) -> Any? in
                return (hosts as! RACTuple).allObjects().map { MacFinder.addMacToHost(host: $0 as! Host) }
            }).subscribeNext({ (hosts:Any?) in
                subscriber?.sendNext(hosts)
                subscriber?.sendCompleted()
            })
            
            return RACDisposable(block: {
            })
        })
    }
    
    static private func getIPPrefix() -> String {
        guard let ip = IPAddress.getWiFiAddress() else {
            return Constants.NO_WIFI_ADDRESS;
        }
        var ipArr = ip.components(separatedBy: ".")
        ipArr.removeLast()
        return ipArr.joined(separator: ".")
    }
    
    static private func signalForPing(ping: PingWrapper) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable? in
            ping.startPing(callback: { (hostname, found) in
                if (found) {
                    subscriber!.sendNext(hostname)
                    subscriber!.sendCompleted()
                    print("\(hostname): was found")
                } else {
                    subscriber!.sendNext(Constants.PING_HOST_NOT_FOUND)
                    subscriber!.sendCompleted()
                }
            })
            
            return RACDisposable(block: {
            })
        })
    }
}

