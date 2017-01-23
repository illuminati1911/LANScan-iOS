//
//  APIManager.swift
//  TestApp
//
//  Created by Ville Välimaa on 22/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import Alamofire
import ReactiveCocoa

let macAPIAddress = "https://api.macvendors.com/"

class APIManager {
    
    static func signalForManufacturers(hosts:Array<Host>) -> RACSignal {
            let signals = hosts.map { signalForManufacturer(host: $0) }
            return RACSignal.combineLatest(signals as NSArray)
    }

    static func signalForManufacturer(host:Host) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable? in
            Alamofire.request("\(macAPIAddress)\(host.macAddress!)").responseString { response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value)")
                if(response.result.isSuccess){
                    subscriber?.sendNext(Host(ipAddress: host.ipAddress, hostname: host.hostname, macAddress: host.macAddress, manufacturer: response.result.value))
                    subscriber?.sendCompleted()
                } else {
                    subscriber?.sendNext(Host(ipAddress: host.ipAddress, hostname: host.hostname, macAddress: host.macAddress, manufacturer: Constants.MANUFACTURER_NOT_FOUND))
                    subscriber?.sendCompleted()
                }
            }
            
            return RACDisposable(block: {
            })
        }).subscribe(on: RACScheduler(priority: RACSchedulerPriorityBackground))
    }
}

