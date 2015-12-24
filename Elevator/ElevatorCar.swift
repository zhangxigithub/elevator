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
    func arrive(car:ElevatorCar,floor:Int)
    func willOpen(car:ElevatorCar)
    func didOpen(car:ElevatorCar)
    func willClose(car:ElevatorCar)
    func didClose(car:ElevatorCar)
}

class ElevatorCar: UIView {
    
    var floor:Int!
    var floorCount:Int!
    
    
    var direction = ElevatorDirection.UP
    var state = ElevatorCarState.Stop

    var leftGate:UIImageView!
    var rightGate:UIImageView!
    var gateState = ElevatorCarGateState.Close
    var delegate:ElevatorCarDelegate?
    
    //var destinationFloors = [Bool]()
    var buttons = [UIButton]()
    
    convenience init(floor:Int,totalFloorCount:Int,frame: CGRect) {
        self.init(frame:frame)
        
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        self.backgroundColor = UIColor.whiteColor()
        self.floor = floor
        self.floorCount = totalFloorCount
        
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("tap"))
        self.addGestureRecognizer(tap)
        
        
        var posotion = CGPointMake(0, 0)
        
        for i in 1...totalFloorCount
        {
            //destinationFloors.append(false)
            let button = UIButton(type: UIButtonType.Custom)
            button.tag = i
            
            let width:CGFloat = 44 //按钮宽度，高度
            let space:CGFloat = 3  //按钮之间的间隔

            if posotion.x + width  > self.frame.size.width
            {
                posotion.x = 0
                posotion.y += (width+space)
            }
            
            button.setBackgroundImage(UIImage(named: "button_bg"), forState: UIControlState.Normal)
            button.frame = CGRectMake(posotion.x, posotion.y, width, width)
            button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: width*0.6)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
            button.setTitle(String(i), forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("selectFloor:"), forControlEvents: UIControlEvents.TouchUpInside)
            button.userInteractionEnabled = true
            
            buttons.append(button)
            self.addSubview(button)
            
            
            posotion.x += (width+space)
        }
        
        
        leftGate  = UIImageView(frame: CGRectMake(0,0,self.frame.size.width/2,self.frame.size.height))
        leftGate.userInteractionEnabled = true
        leftGate.image = UIImage(named: "door_left")
        self.addSubview(leftGate)
        
        
        rightGate = UIImageView(frame: CGRectMake(self.frame.size.width/2,0,self.frame.size.width/2,self.frame.size.height))
        rightGate.userInteractionEnabled = true
        rightGate.image = UIImage(named: "door_right")
        self.addSubview(rightGate)
        

    }
    
    func selectFloor(button:UIButton)
    {

        button.selected = true
        self.delegate?.didSelectFloor(self, floor: button.tag)
    }
    func arrive(floor:Int)
    {
        self.state = .Stop
        self.floor = floor
        buttons[floor-1].selected = false
        
        self.delegate?.arrive(self,floor:floor)
        
        self.openGate()
    }

    func openGate()
    {
        let leftGateOpenFrame   = CGRectMake(-self.frame.size.width/2  ,0,self.frame.size.width/2,self.frame.size.height)
        let rightGateOpenFrame  = CGRectMake(self.frame.size.width     ,0,self.frame.size.width/2,self.frame.size.height)
        
        
        gateState = ElevatorCarGateState.Opennig
        self.delegate?.willOpen(self)
        UIView.animateWithDuration(1, animations: { () -> Void in
            
            self.leftGate.frame  = leftGateOpenFrame
            self.rightGate.frame = rightGateOpenFrame
            
            }) { (finish:Bool) -> Void in
                self.delegate?.didOpen(self)
                self.gateState = ElevatorCarGateState.Open
                self.closeAfter(3)
        }
    }
    func closeAfter(time:UInt64)
    {
        let wait = dispatch_time(DISPATCH_TIME_NOW, (Int64)(time * NSEC_PER_SEC))

        dispatch_after(wait, dispatch_get_main_queue()) { () -> Void in
            
            self.closeGate()
        }
    }
    
    func closeGate()
    {
        let leftGateCloseFrame  = CGRectMake(0                         ,0,self.frame.size.width/2,self.frame.size.height)
        let rightGateCloseFrame = CGRectMake(self.frame.size.width/2   ,0,self.frame.size.width/2,self.frame.size.height)
        

        self.gateState = ElevatorCarGateState.Closing
        self.delegate?.willClose(self)
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.leftGate.frame  = leftGateCloseFrame
            self.rightGate.frame = rightGateCloseFrame
            }) { (finish:Bool) -> Void in
                
                self.gateState = ElevatorCarGateState.Close
                self.delegate?.didClose(self)
        }
    }
    
    
    func tap()
    {
        if gateState == ElevatorCarGateState.Close
        {
            self.openGate()
        }
    }
    
    
}
