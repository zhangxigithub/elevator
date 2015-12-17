//
//  Elevator.swift
//  Elevator
//
//  Created by zhangxi on 12/17/15.
//  Copyright © 2015 zhangxi.me. All rights reserved.
//

import UIKit

class Elevator: UIView {

    let car = ElevatorCar()
    
    
    var floorCount:Int!
    var controlPanels = [ElevatorControlPanel]()
    
    
    convenience init(numberOfFloor:Int,frame: CGRect) {

        self.init(frame:frame)
        floorCount = numberOfFloor

        self.backgroundColor = UIColor.redColor()
        
        
        
        
        for i in 1 ... numberOfFloor
        {
            let floorFrame = frameWithFloor(i)
            let floor = UIView(frame: floorFrame)
            
            let panel = ElevatorControlPanel(floor: i, frame: CGRectMake(0, 0, 25, 65))
            panel.center = CGPointMake(floor.frame.size.width-30, floor.frame.size.height/2)
            
            
            
            
            floor.addSubview(panel)
            self.addSubview(floor)
        }
    }
    
    
    func frameWithFloor(floor:Int) -> CGRect
    {
        let floorHeight = (self.frame.size.height / CGFloat(floorCount))
        let y = self.frame.size.height - CGFloat(floor)*floorHeight

        return CGRectMake(0, y, self.frame.size.width, floorHeight)
    }

    
}
