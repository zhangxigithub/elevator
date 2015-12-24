//
//  ElevatorControlPanel.swift
//  Elevator
//
//  Created by zhangxi on 12/17/15.
//  Copyright © 2015 zhangxi.me. All rights reserved.
//

import UIKit

protocol ElevatorControlPanelDelegate
{
    func up(panel:ElevatorControlPanel)
    func down(panel:ElevatorControlPanel)
}

class ElevatorControlPanel: UIView {

    var delegate:ElevatorControlPanelDelegate?
    
    
    
    var floor:Int!  //楼层号
    
    var upButton:UIButton!
    var downButton:UIButton!
    
    var needUp      = false   //按下上行
        {
        didSet{
            upButton.selected = needUp
        }
        
    }
    var needDown    = false   //按下下行
        {
        didSet{
            downButton.selected = needUp
        }
    }
    
    var destination = false   //目的地楼层，电梯内有人选了该楼层
    

    convenience init(floor:Int,frame: CGRect) {
        
        self.init(frame:frame)
        
        //self.backgroundColor = UIColor.whiteColor()
        //self.layer.borderColor = UIColor(white: 0.9, alpha: 1).CGColor
        //self.layer.borderWidth = 1
        
        
        self.floor = floor

        let space:CGFloat = 2
        let width  = self.frame.size.width  - space*2
        let height = (self.frame.size.height - space)/2

        
        upButton = UIButton(type: UIButtonType.Custom)
        upButton.frame = CGRectMake(space, space, width, height)
        upButton.setImage(UIImage(named: "up"), forState: UIControlState.Normal)
        upButton.setImage(UIImage(named: "up_s"), forState: UIControlState.Selected)
        upButton.addTarget(self, action: Selector("up:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(upButton)
        
        downButton = UIButton(type: UIButtonType.Custom)
        downButton.frame = CGRectMake(space,height+space, width, height)
        downButton.setImage(UIImage(named: "down"), forState: UIControlState.Normal)
        downButton.setImage(UIImage(named: "down_s"), forState: UIControlState.Selected)
        downButton.addTarget(self, action: Selector("down:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(downButton)
    }
    
    func up(button:UIButton)
    {
        //dispatch_async(dispatch_get_main_queue()) { () -> Void in
            needUp = true
            self.upButton.selected = true
            self.delegate?.up(self)
        //}


    }
    
    func down(button:UIButton)
    {
        //dispatch_async(dispatch_get_main_queue()) { () -> Void in
            needDown = true
        self.downButton.selected = true
            self.delegate?.down(self)
        //}
    }
}
