//
//  ElevatorCar.swift
//  Elevator
//
//  Created by zhangxi on 12/17/15.
//  Copyright © 2015 zhangxi.me. All rights reserved.
//

import UIKit


enum ElevatorCarState
{
    case Stop
    case MovingUp
    case MovingDown
}
enum ElevatorCarGateState
{
    case Open
    case Close
    case Opennig
    case Closing
}


protocol ElevatorCarDelegate
{
    func didSelectFloor(car:ElevatorCar,floor:Int)
}

class ElevatorCar: UIView {
    
    var floor:Int!
    var floorCount:Int!
    
    var state = ElevatorCarState.Stop
    var leftGate:UIView!
    var rightGate:UIView!
    var gateStatr = ElevatorCarGateState.Close
    var delegate:ElevatorCarDelegate?
    
    
    convenience init(floor:Int,totalFloorCount:Int,frame: CGRect) {
        self.init(frame:frame)
        self.backgroundColor = UIColor.whiteColor()
        self.floor = floor
        self.floorCount = totalFloorCount
        
        
        
        
        
        for i in 1...totalFloorCount
        {
            let button = UIButton(type: UIButtonType.Custom)
            button.tag = i
            button.frame = CGRectMake(0, 0, 50, 50)
            button.backgroundColor = UIColor(white: 0.9, alpha: 1)
            button.setTitle(String(i), forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("selectFloor:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            self.addSubview(button)
        }
        
        

        
        leftGate  = UIView(frame: CGRectMake(0,0,self.frame.size.width/2,self.frame.size.height))
        leftGate.backgroundColor = UIColor.grayColor()
        self.addSubview(leftGate)
        
        rightGate = UIView(frame: CGRectMake(self.frame.size.width/2,0,self.frame.size.width/2,self.frame.size.height))
        rightGate.backgroundColor = UIColor.grayColor()
        self.addSubview(rightGate)
        

    }
    
    func selectFloor(button:UIButton)
    {
        self.delegate?.didSelectFloor(self, floor: button.tag)
    }
    

    func openGate()
    {
        let leftGateOpenFrame   = CGRectMake(-self.frame.size.width/2  ,0,self.frame.size.width/2,self.frame.size.height)
        let rightGateOpenFrame  = CGRectMake(self.frame.size.width     ,0,self.frame.size.width/2,self.frame.size.height)
        
        
        gateStatr = ElevatorCarGateState.Opennig
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            
            self.leftGate.frame  = leftGateOpenFrame
            self.rightGate.frame = rightGateOpenFrame
            
            }) { (finish:Bool) -> Void in
                self.gateStatr = ElevatorCarGateState.Open
        }
        
    }
    
    func closeGate()
    {
        let leftGateCloseFrame  = CGRectMake(0                         ,0,self.frame.size.width/2,self.frame.size.height)
        let rightGateCloseFrame = CGRectMake(self.frame.size.width/2   ,0,self.frame.size.width/2,self.frame.size.height)
        

        self.gateStatr = ElevatorCarGateState.Closing
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.leftGate.frame  = leftGateCloseFrame
            self.rightGate.frame = rightGateCloseFrame
            }) { (finish:Bool) -> Void in
                
                self.gateStatr = ElevatorCarGateState.Close
        }
    }
    
}
