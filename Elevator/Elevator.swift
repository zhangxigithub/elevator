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
    case AnyDirection
}



class Elevator: UIView,ElevatorControlPanelDelegate,ElevatorCarDelegate {

    var car:ElevatorCar!
    var floorCount:Int!
    var controlPanels = [ElevatorControlPanel]()
    

    
    
    let controlPanelWidth :CGFloat = 80
    let controlPanelHeight:CGFloat = 120
    
    

    func scan()
    {
        print("scanAction.........")
        
        //当电梯停止的时候 或者 门没关的时候不移动电梯
        if car.state != ElevatorCarState.Stop
        {
            return
        }
        if car.gateState != .Close
        {
            return
        }

        
        //当待机状态时，选择最近的目的地
        if car.direction == .AnyDirection
        {
            if let p = latestRequest(car.floor)
            {
                look(p)
                return
            }
            return
        }
        
        //1.先扫描同方向上的请求
        if let p = sameDirectionRequest(car.floor, direction: car.direction)
        {
            look(p)
            return
        }
        //2.同方向上没有请求，改变方向
        changeDirection()
        //3.扫描反方向的请求
        if let p = opsiteDirectionRequest(car.floor, direction: car.direction)
        {
            look(p)
            return
        }
        print("待机")
        car.direction = .AnyDirection
    }
    func look(panel:ElevatorControlPanel)
    {
        if panel.destination == true
        {//电梯内有人按楼层，优先到达该楼层
            moveTo(panel.floor, direction:car.direction)
        }else
        {//电梯外有人请求电梯，次优先
            moveTo(panel.floor, direction:car.direction)
        }
    }
    





    //同方向最近的的请求
    func sameDirectionRequest(floor:Int,direction:ElevatorDirection) -> ElevatorControlPanel?
    {
        
        if direction == .UP
        {
            for i in floor...floorCount
            {
                let p = panel(floor: i)
                if p.needUp == true || p.destination == true
                {
                    return p
                }
            }
        }else
        {
            for var i = floor ;i>=1 ; i-=1
            {
                let p = panel(floor: i)
                if p.needDown == true || p.destination == true
                {
                    return p
                }
            }
        }
        return nil
    }
    //相反方向最近的的请求
    func opsiteDirectionRequest(floor:Int,direction:ElevatorDirection) -> ElevatorControlPanel?
    {
        if direction == .UP
        {
            for i in 1...floorCount
            {
                let p = panel(floor: i)
                if p.needUp == true || p.destination == true
                {
                    return p
                }
            }
        }else
        {
            for var i = floorCount! ;i>=1 ; i-=1
            {
                let p = panel(floor: i)
                if p.needDown == true || p.destination == true
                {
                    return p
                }
            }
        }
        return nil
    }
    //同方向最近的的请求
    func latestRequest(floor:Int) -> ElevatorControlPanel?
    {
        
        var finish    = false
        var downIndex = floor-1
        var upIndex   = floor+1

        while !finish
        {
            finish = true
            if upIndex <= floorCount
            {
                finish = false
                let panel = self.panel(floor: upIndex)
                if panel.destination == true || panel.needUp == true || panel.needDown == true
                {
                    self.car.direction = .UP
                    return panel
                }
            }
            upIndex++
            if downIndex >= 0
            {
                finish = false
                let panel = self.panel(floor: downIndex)
                if panel.destination == true || panel.needUp == true || panel.needDown == true
                {
                    self.car.direction = .DOWN
                    return panel
                }
            }
            downIndex--
        }
        
        

        return nil
    }

    
    
    
    
    func moveTo(floor:Int,direction:ElevatorDirection)
    {
        print("moveTo \(floor)")
        let newFrame = carFrame(floor)
        
        let duration = NSTimeInterval(abs(floor - car.floor))
        print("duration \(duration)")
        self.car.state = .MovingUp
        self.car.direction = direction
            
        UIView.animateWithDuration(duration, animations: { () -> Void in
            
            self.car.frame = newFrame
            
            }) { (finish:Bool) -> Void in
                
                
                self.car.arrive(floor)
                
                let panel = self.panel(floor: floor)

                //panel.needUp   = false
                //panel.needDown   = false
                if direction == .UP
                {
                    panel.needUp   = false
                }else
                {
                    panel.needDown = false
                }
                
                
        }
    }
    


    
    
    
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
        print("\(panel.floor)楼 need up")
        if car.direction == .AnyDirection
        {
            car.direction = .UP
        }
        scan()
    }
    func down(panel: ElevatorControlPanel)
    {
        print("\(panel.floor)楼 need down")
        if car.direction == .AnyDirection
        {
            car.direction = .DOWN
        }
        scan()
    }
    
    //MARK: - ElevatorCarDelegate
    func didSelectFloor(car: ElevatorCar, floor: Int) {
        print("need fo to \(floor)")
        panel(floor: floor).destination = true
        if car.direction == .AnyDirection
        {
            self.car.direction = (floor > car.floor) ? .UP : .DOWN
        }
        
        
    }
    
    func arrive(car: ElevatorCar, floor: Int) {
        
        let panel = self.panel(floor: floor)
        panel.destination = false
        
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
        scan()
    }
    
    
    
    //MARK: - ===
    convenience init(numberOfFloor:Int,frame: CGRect) {

        self.init(frame:frame)
        floorCount = numberOfFloor

        
    
        car = ElevatorCar(floor: 1,totalFloorCount:numberOfFloor, frame: carFrame(1))
        car.delegate = self
        car.direction = .AnyDirection
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
    

    func panel(floor floor:Int)->ElevatorControlPanel
    {
        return controlPanels[floor-1]
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
