//
//  EleveotrManager.swift
//  Elevator
//
//  Created by zhangxi on 12/24/15.
//  Copyright © 2015 zhangxi.me. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import AdSupport

class EleveotrManager: NSObject, MCBrowserViewControllerDelegate,MCSessionDelegate,MCNearbyServiceAdvertiserDelegate,MCNearbyServiceBrowserDelegate{

    
    
    static let sharedManager: EleveotrManager = {
        

        
        return EleveotrManager()
    }()
    

    
    var advertisier:MCNearbyServiceAdvertiser!
    var browser:MCNearbyServiceBrowser!
    var session:MCSession!
    
    override init() {
        super.init()
        
        

        let ID = ASIdentifierManager.sharedManager().advertisingIdentifier.UUIDString
        let peerID = MCPeerID(displayName: ID)
        
        let serviceType = "elevator-zx"
        
        
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser.delegate = self
        browser.startBrowsingForPeers()
        
        
        advertisier  = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertisier.delegate = self
        advertisier.startAdvertisingPeer()

        
        
        session = MCSession(peer: peerID)
        session.delegate = self
        
        
        print("start")

    }

    //MARK: - MCNearbyServiceAdvertiserDelegate
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        
        print("didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true,session)
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        print("didNotStartAdvertisingPeer \(error)")
    }
    
    
    //MARK: - MCNearbyServiceBrowserDelegate
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?)
    {
        print("foundPeer \(peerID)")
        browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 20)
    }
    
    // A nearby peer has stopped advertising.
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID)
    {
        print("lostPeer \(peerID)")
    }
    
    
    //MARK: - MCSessionDelegate
    @available(iOS 7.0, *)
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState)
    {
        print("\(peerID) didChangeState \(state)")
        switch state
        {
        case .NotConnected:
            print("NotConnected")
        case .Connecting:
            print("Connecting")
        case .Connected:
            print("Connected")
            try? session.sendData("ddddd".dataUsingEncoding(NSUTF8StringEncoding)!, toPeers: [peerID], withMode: MCSessionSendDataMode.Reliable)
            
        }
    }
    
    // Received data from remote peer.
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID)
    {
        print("\(session) didReceiveData \(data)  from \(peerID)")
        print("string:\(String(data: data, encoding: NSUTF8StringEncoding))")
    }
    
    // Received a byte stream from remote peer.
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    {
        print("didReceiveStream")
    }
    
    // Start receiving a resource from remote peer.
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress)
    {
        print("didStartReceivingResourceWithName")
    }
    
    // Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?)
    {
        print("didFinishReceivingResourceWithName")
    }
    
    // Made first contact with peer and have identity information about the
    // remote peer (certificate may be nil).
//
//    func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void)
//    {
//    }
    
    
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        
    }
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        
    }
    func start()
    {

    }
    
}
