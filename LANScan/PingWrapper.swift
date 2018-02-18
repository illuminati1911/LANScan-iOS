//
//  Ping.swift
//  TestApp
//
//  Created by Ville Välimaa on 18/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//


class PingWrapper: NSObject {

    public typealias PingCompletion = (_ hostname:String, _ found:Bool) -> ()
    
    private var ping:SimplePing?
    private var timeoutTimer:Timer?
    private var hostName: String
    private var completion:PingCompletion?
    
    init(hostName:String) {
        self.hostName = hostName
        super.init()
        ping = SimplePing(hostName: hostName)
        ping?.addressStyle = .icmPv4
        ping?.delegate = self
    }
    
    func startPing(callback: @escaping PingCompletion) {
        completion = callback
        ping?.start()
    }
    
    private func stopPing() {
        guard let simplePing = ping else { return }
        simplePing.stop()
        
        guard let timer = timeoutTimer, timer.isValid else { return }
        timer.invalidate()
        timeoutTimer = nil
    }
    
    @objc func timeout() {
        hostFound(false)
    }
    
    private func hostFound(_ found:Bool) {
        stopPing()
        completion?(hostName, found)
    }
}

//-------------------- SIMPLE PING DELEGATE --------------------//
//
extension PingWrapper: SimplePingDelegate {
    
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        timeoutTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timeout), userInfo: nil, repeats: false)
        ping?.send(with: nil)
    }
    
    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        hostFound(false)
    }
    
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        hostFound(true)
    }
    
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) { }
    
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) { }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        print("ERROR FAIL TO SEND \(self.hostName)");
        print(error.localizedDescription)
        hostFound(false)
    }

}
