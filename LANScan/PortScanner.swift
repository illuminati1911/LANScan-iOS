//
//  PortScanner.swift
//  LANScan
//
//  Created by Ville Välimaa on 04/03/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import Foundation
import SwiftSocket
import ReactiveCocoa

class PortScanner {
    
    static func scanPortsOn(host:Host) -> RACSignal {
        guard let ip = host.ipAddress else { return RACSignal() }
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable? in
            DispatchQueue.global(qos: .background).async {
                (Array(1...100)
                .map { signalForPort(port: $0, ipAddress: ip) } as NSArray
                |> RACSignal.combineLatest)
                .deliverOnMainThread()
                .subscribeNext({ (services:Any?) in
                let finalServices = ((services as! RACTuple).allObjects() as! Array<String>)
                .filter { $0 != Constants.NO_SERVICE }
                    subscriber!.sendNext(finalServices)
                    subscriber?.sendCompleted()
                })
            }
            return RACDisposable(block: {
            })
        })
    }
    
    private static func signalForPort(port:Int32, ipAddress:String) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable? in
                let client = TCPClient(address: ipAddress, port: port)
                switch client.connect(timeout: 1) {
                case .success:
                    subscriber?.sendNext(String(port))
                    subscriber?.sendCompleted()
                case .failure:
                    subscriber?.sendNext(Constants.NO_SERVICE)
                    subscriber?.sendCompleted()
                }
            return RACDisposable(block: {
            })
        })
    }
}
