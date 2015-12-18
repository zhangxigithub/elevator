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

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    var floor:Int!
    var delegate:ElevatorControlPanelDelegate?
    
    
    var needUp   = false
    var needDown = false
    
    
    var upButton:UIButton!
    var downButton:UIButton!
    
    convenience init(floor:Int,frame: CGRect) {
        
        self.init(frame:frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor(white: 0.9, alpha: 1).CGColor
        self.layer.borderWidth = 1
        
        
        self.floor = floor

        let space:CGFloat = 2
        let width = self.frame.size.width - space*2

        
        upButton = UIButton(type: UIButtonType.Custom)
        upButton.frame = CGRectMake(space, space, width, width)
        upButton.setImage(UIImage(named: "up"), forState: UIControlState.Normal)
        upButton.setImage(UIImage(named: "up_s"), forState: UIControlState.Selected)
        upButton.addTarget(self, action: Selector("up:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(upButton)
        
        downButton = UIButton(type: UIButtonType.Custom)
        downButton.frame = CGRectMake(space, self.frame.size.height-width-space, width, width)
        downButton.setImage(UIImage(named: "down"), forState: UIControlState.Normal)
        downButton.setImage(UIImage(named: "down_s"), forState: UIControlState.Selected)
        downButton.addTarget(self, action: Selector("down:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(downButton)
    }
    
    func up(button:UIButton)
    {
        button.selected = true
        needUp = true
        self.delegate?.up(self)

    }
    
    func down(button:UIButton)
    {
        button.selected = true
        needDown = true
        self.delegate?.down(self)
    }
}
