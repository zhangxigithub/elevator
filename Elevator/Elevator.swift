//
//  Elevator.swift
//  Elevator
//
//  Created by zhangxi on 12/17/15.
//  Copyright © 2015 zhangxi.me. All rights reserved.
//

import UIKit

class Elevator: UIView,ElevatorControlPanelDelegate {

    var car:ElevatorCar!
    
    
    var floorCount:Int!
    var controlPanels = [ElevatorControlPanel]()
    
    
    func up(panel: ElevatorControlPanel)
    {
        print("\(panel.floor) need up")
        
        let newFrame = frameWithFloor(panel.floor)
        UIView.animateWithDuration(1) { () -> Void in
            self.car.frame = newFrame
        }
        
    }
    func down(panel: ElevatorControlPanel)
    {
        print("\(panel.floor) need down")
        
        let newFrame = frameWithFloor(panel.floor)
        UIView.animateWithDuration(2) { () -> Void in
            self.car.frame = newFrame
        }
    }
    
    
    convenience init(numberOfFloor:Int,frame: CGRect) {

        self.init(frame:frame)
        floorCount = numberOfFloor

        self.backgroundColor = UIColor.redColor()
        
    
        car = ElevatorCar(floor: 0, frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/CGFloat(floorCount)))
        self.addSubview(car)
        
        
        for i in 1 ... numberOfFloor
        {
            let floorFrame = frameWithFloor(i)
            let floor = UIView(frame: floorFrame)
            
            let panel = ElevatorControlPanel(floor: i, frame: CGRectMake(0, 0, 30, 65))
            panel.center = CGPointMake(floor.frame.size.width-30, floor.frame.size.height/2)
            panel.delegate = self
            
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
