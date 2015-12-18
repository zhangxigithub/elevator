//
//  ViewController.swift
//  Elevator
//
//  Created by zhangxi on 12/17/15.
//  Copyright © 2015 zhangxi.me. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 1100)
        self.view.addSubview(scrollView)
        
        let elevator = Elevator(numberOfFloor: 10, frame: CGRectMake(0, 0,scrollView.contentSize.width, scrollView.contentSize.height))
        scrollView.addSubview(elevator)
        
    }


}

