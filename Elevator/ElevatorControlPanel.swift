//
//  ElevatorControlPanel.swift
//  Elevator
//
//  Created by zhangxi on 12/17/15.
//  Copyright © 2015 zhangxi.me. All rights reserved.
//

import UIKit

class ElevatorControlPanel: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    var floor:Int!
    
    convenience init(floor:Int,frame: CGRect) {
        
        self.init(frame:frame)
        
        self.floor = floor
        
        let width = self.frame.size.width
        
        let up = UIButton(type: UIButtonType.Custom)
        up.frame = CGRectMake(0, 0, width, width)
        up.setImage(UIImage(named: "up"), forState: UIControlState.Normal)
        up.setImage(UIImage(named: "up_s"), forState: UIControlState.Selected)
        up.addTarget(self, action: Selector("up"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(up)
        
        let down = UIButton(type: UIButtonType.Custom)
        down.frame = CGRectMake(0, self.frame.size.height-width, width, width)
        down.setImage(UIImage(named: "down"), forState: UIControlState.Normal)
        down.setImage(UIImage(named: "down_s"), forState: UIControlState.Selected)
        down.addTarget(self, action: Selector("down"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(down)
    }
    
    func up()
    {
    }
    
    func down()
    {
    }
}
