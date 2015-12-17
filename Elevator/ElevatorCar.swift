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


class ElevatorCar: UIView {
    
    var floor:Int!
    var state = ElevatorCarState.Stop
    
    convenience init(floor:Int,frame: CGRect) {
        self.init(frame:frame)
        self.backgroundColor = UIColor.blueColor()
        self.floor = floor
    }
    
}
