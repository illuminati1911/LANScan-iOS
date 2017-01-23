//
//  Ping.swift
//  TestApp
//
//  Created by Ville Välimaa on 18/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//


class PingWrapper: NSObject, SimplePingDelegate {

    public typealias PingCompletion = (_ hostname:String, _ found:Bool) -> ()
    
    var ping:SimplePing!
    var timeoutTimer:Timer?
    var hostName:String?
    var completion:PingCompletion?
    
    init(hostName:String) {
        super.init()
        self.ping = SimplePing(hostName: hostName)
        self.hostName = hostName
        self.ping.addressStyle = .icmPv4
        self.ping.delegate = self
    }
    
    func startPing(completion: @escaping PingCompletion) {
        self.completion = completion
        self.ping.start()
    }
    
    func stopPing() {
        if let simpleping = self.ping {
            simpleping.stop()
        }
        
        if self.timeoutTimer != nil && self.timeoutTimer!.isValid {
            self.timeoutTimer!.invalidate()
            self.timeoutTimer = nil
        }
    }
    
    func timeout() {
        self.host(found: false)
    }
    
    func host(found:Bool) {
        self.stopPing()
        if self.hostName != nil {
            self.completion?(hostName!, found)
        }else{
            self.completion?("No hostname", found)
        }
        
    }
    
    
    
    //-------------------- SIMPLE PING DELEGATE --------------------//

    
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        self.timeoutTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timeout), userInfo: nil, repeats: false)
        self.ping.send(with: nil)
    }
    
    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        self.host(found: false)
        //print("ERROR DID FAIL WITH ERROR \(self.hostName)");
    }
    
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        self.host(found: true)
    }
    
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        //self.host(found: false)
        //print("ERROR UNEXPECTED :D \(self.hostName)");
        //print(packet.description)
    }
    
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        
    }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        //print("ERROR FAIL TO SEND \(self.hostName)");
        //print(error.localizedDescription)
        self.host(found: false)
    }
}

