//
//  Elevator.swift
//  Elevator
//
//  Created by zhangxi on 12/17/15.
//  Copyright © 2015 zhangxi.me. All rights reserved.
//

import UIKit




enum ElevatorDirection
{
    case UP
    case DOWN
}

class ElevatorAction
{
    var directon:ElevatorDirection!
    var floor:Int!
    //var destinationFloor:Int!
}

class Elevator: UIView,ElevatorControlPanelDelegate,ElevatorCarDelegate {

    var car:ElevatorCar!
    var floorCount:Int!
    

    
    var controlPanels = [ElevatorControlPanel]()
    var actions = [ElevatorAction]()
    var currentAction:ElevatorAction?
    
    
    
    
    let controlPanelWidth :CGFloat = 30
    let controlPanelHeight:CGFloat = 65
    
    

    func scanAction()
    {
//        if car.state != ElevatorCarState.Stop
//        {
//            return
//        }
        if car.direction == .UP
        {
            for i in car.floor...floorCount
            {
                let panel = controlPanels[i-1]
                if panel.needUp
                {
                    moveTo(panel.floor,direction:.UP)
                    return
                }
            }
            
            for var i = car.floor! ;i>=1 ; i-=1
            {
                let panel = controlPanels[i-1]
                if panel.needDown
                {
                    moveTo(panel.floor,direction:.DOWN)
                    return
                }
            }
            
            
            
        }else
        {
            for i in car.floor...1
            {
                let panel = controlPanels[i-1]
                if panel.needDown
                {
                    moveTo(panel.floor,direction:.DOWN)
                    return
                }
            }
           for var i = car.floor! ;i>=1 ; i-=1
            {
                let panel = controlPanels[i-1]
                if panel.needUp
                {
                    moveTo(panel.floor,direction:.UP)
                    return
                }
            }
        }
    }
    func scanCarAction()
    {
        if car.state != ElevatorCarState.Stop
        {
            return
        }
        if car.direction == .UP
        {
            for i in car.floor...floorCount
            {
                let needStop = car.destinationFloors[i-1]
                if needStop
                {
                    moveTo(i,direction:.UP)
                    return
                }
            }
        }else
        {
            for i in car.floor...1
            {
                let needStop = car.destinationFloors[i-1]
                if needStop
                {
                    moveTo(i,direction:.DOWN)
                    return
                }
            }
        }
    }
    
    
    
    
    func moveTo(floor:Int,direction:ElevatorDirection)
    {
        let newFrame = carFrame(floor)
        
        let duration = NSTimeInterval(abs(floor - car.floor))
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            
            self.car.frame = newFrame
            
            }) { (finish:Bool) -> Void in
                
                
                self.car.arrive(floor)
                
                let panel = self.controlPanels[floor-1]

                if direction == .UP
                {
                    panel.needUp   = false
                }else
                {
                    panel.needDown = false
                }
                self.car.openGate()
                
        }
    }
    
//    func runAction(action:ElevatorAction)
//    {
//
//        currentAction = action
//        direction = (action.floor > car.floor) ? .UP : .DOWN
//       
//    
//        moveTo(action.floor)
//    }
//    
    
    
    
//    
//    func findLatestSameDirectionAction() -> ElevatorAction?
//    {
//    }

    
    
    
    func changeDirection()
    {
        if car.direction == .UP
        {
            car.direction = .DOWN
        }else
        {
            car.direction == .UP
        }
    }
    
    
    //MARK: - ElevatorControlPanelDelegate
    func up(panel: ElevatorControlPanel)
    {
        print("\(panel.floor) need up")
        scanAction()
    }
    func down(panel: ElevatorControlPanel)
    {
        print("\(panel.floor) need down")
        scanAction()
    }
    
    //MARK: - ElevatorCarDelegate
    func didSelectFloor(car: ElevatorCar, floor: Int) {
       print("need fo to \(floor)")
        
        
    }
    func arrive(car: ElevatorCar, floor: Int) {
        let panel = controlPanels[floor-1]
        if car.direction == .UP
        {
            panel.upButton.selected = false
        }else
        {
            panel.downButton.selected = false
        }
        
    }
    func willOpen(car:ElevatorCar)
    {
        print("willOpen")
    }
    func didOpen(car:ElevatorCar)
    {
        print("didOpen")
    }
    func willClose(car:ElevatorCar)
    {
        print("willClose")
    }
    func didClose(car:ElevatorCar)
    {
        print("didClose 当前楼层\(car.floor)")
        scanAction()
        scanCarAction()
    }
    
    
    convenience init(numberOfFloor:Int,frame: CGRect) {

        self.init(frame:frame)
        floorCount = numberOfFloor

        
    
        car = ElevatorCar(floor: 1,totalFloorCount:numberOfFloor, frame: carFrame(1))
        car.delegate = self
        self.addSubview(car)
        
        
        for i in 1 ... numberOfFloor
        {
            let floor = UIView(frame: controlPanelFrame(i))
            
            let panel = ElevatorControlPanel(floor: i, frame: CGRectMake(0, 0, controlPanelWidth, controlPanelHeight))
            panel.center = CGPointMake(controlPanelWidth/2, floor.frame.size.height/2)
            panel.delegate = self
            
            self.controlPanels.append(panel)
            floor.addSubview(panel)
            self.addSubview(floor)
        }
        

    }
    

    func controlPanelFrame(floor:Int) -> CGRect
    {
        let floorHeight = (self.frame.size.height / CGFloat(floorCount))
        let y = self.frame.size.height - CGFloat(floor)*floorHeight
        
        return CGRectMake(self.frame.size.width-controlPanelWidth, y,controlPanelWidth, floorHeight)
    }
    func floorFrame(floor:Int) -> CGRect
    {
        let floorHeight = (self.frame.size.height / CGFloat(floorCount))
        let y = self.frame.size.height - CGFloat(floor)*floorHeight

        return CGRectMake(0, y,self.frame.size.width, floorHeight)
    }
    func carFrame(floor:Int) -> CGRect
    {
        let floorHeight = (self.frame.size.height / CGFloat(floorCount))
        let y = self.frame.size.height - CGFloat(floor)*floorHeight
        
        return CGRectMake(0, y,self.frame.size.width-controlPanelWidth, floorHeight)
    }

    
}
