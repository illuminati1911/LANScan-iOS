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
    
    static func signalForManufacturers(hosts:Any?) -> RACSignal {
        let hosts = hosts as! Array<Host>
        let signals = hosts.map { signalForManufacturer(host: $0) }
        return RACSignal.combineLatest(signals as NSArray)
    }

    private static func signalForManufacturer(host: Host) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable? in
            let datarequest = Alamofire.request("\(macAPIAddress)\(host.macAddress!)")
            DispatchQueue.global().async {
                datarequest.responseString { response in
                    subscriber?.sendNext(
                        Host(ipAddress: host.ipAddress,
                             hostname: host.hostname,
                             macAddress: host.macAddress,
                             manufacturer: response.result.isSuccess
                                ? response.result.value
                                : Constants.MANUFACTURER_NOT_FOUND))
                }
            }
            
            return RACDisposable(block: {
                datarequest.cancel()
            })
        }).subscribe(on: RACScheduler(priority: RACSchedulerPriorityBackground))
    }
}
